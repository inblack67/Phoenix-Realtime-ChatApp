import { Socket } from 'phoenix';

let socket = new Socket('/socket', { params: { token: window.userToken } });

socket.connect();

const roomId = window.roomId;

// dont connect without the room id
if (roomId) {
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
    displayMessage(message.body);
  });

  document.querySelector('#message-form').addEventListener('submit', (e) => {
    e.preventDefault();
    const input = e.target.querySelector('#message-body');
    channel.push('message:add', { message: input.value });
    input.value = '';
  });

  const displayMessage = (message) => {
    const template = `<li>
${message}
</li>`;
    const list = document.querySelector('#message-list');
    list.innerHTML += template;
  };
}

export default socket;
