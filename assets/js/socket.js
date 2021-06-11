import { Socket, Presence } from 'phoenix';

let socket = new Socket('/socket', { params: { token: window.userToken } });

socket.connect();

const roomId = window.roomId;

// dont connect without the room id
if (roomId) {
  const timeout = 3000;
  let typingTimer;
  let userTyping = false;
  let presences = {};
  let channel = socket.channel(`room:${roomId}`, {});
  channel
    .join()
    .receive('ok', (resp) => {
      console.log('Joined successfully', resp);
    })
    .receive('error', (resp) => {
      console.log('Unable to join', resp);
    });

  channel.on(`room:${roomId}:new_message`, (message) => {
    displayMessage(message);
  });

  // when user joins or leabes
  channel.on('presence_state', (state) => {
    presences = Presence.syncState(presences, state);
    displayUsers(presences);
  });

  // change happens when user is inside
  // presence is like git
  channel.on('presence_diff', (diff) => {
    presences = Presence.syncDiff(presences, diff);
    displayUsers(presences);
  });

  document.querySelector('#message-body').addEventListener('keydown', () => {
    userStartsTyping();
    clearTimeout(typingTimer);
  });
  document.querySelector('#message-body').addEventListener('keyup', () => {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(userStopTyping, timeout);
  });

  const userStartsTyping = () => {
    if (userTyping) {
      return;
    }

    userTyping = true;
    channel.push('user:typing', {
      typing: true,
    });
  };

  const userStopTyping = () => {
    clearTimeout(typingTimer);
    userTyping = false;

    channel.push('user:typing', {
      typing: false,
    });
  };

  document.querySelector('#message-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const input = e.target.querySelector('#message-body');
    channel.push('message:add', { message: input.value });
    input.value = '';
  });

  const displayMessage = (message) => {
    const template = `<li>
${message.user} => ${message.body}
</li>`;
    const list = document.querySelector('#message-list');
    list.innerHTML += template;
  };

  const displayUsers = (presences) => {
    console.log('presences = ', presences);
    const usersOnline = Presence.list(
      presences,
      (_id, { metas: [user, ...rest] }) => {
        let typingTemplate = '';
        if (user.typing) {
          typingTemplate = ' <i>(Typing...)</i>';
        }
        return `
        <div id="user-${user.user_id}"><strong class="text-secondary">${user.username}</strong> ${typingTemplate}</div>
      `;
      },
    ).join('');
    document.querySelector('#online-users').innerHTML = usersOnline;
  };
}

export default socket;
