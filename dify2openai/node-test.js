


let main = async function () {
  const response = await fetch('http://192.168.89.1:13000/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer app-NsOiZChfDrZPD0PcxKGyURCT',
      'Authorization': 'app-iQ7Gw2yANOORHkBnaUnKgVMV',
    },
    body: JSON.stringify({
      model: 'dify',
      messages: [
        { role: 'system', content: 'You are a helpful assistant.' },
        { role: 'user', content: 'Hello, how are you?' },
      ],
    }),
  });

  const data = await response.json();
  console.log(data);
}
main()