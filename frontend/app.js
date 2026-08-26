const API_URL = "https://ikf2hma291.execute-api.us-east-1.amazonaws.com/Prod/notes";

async function loadNotes() {
  const res = await fetch(API_URL);
  const notes = await res.json();

  const container = document.getElementById("notes");
  container.innerHTML = "";

  notes.forEach(note => {
    const div = document.createElement("div");
    div.className = "note";

    div.innerHTML = `
      <strong>${note.title}</strong>
      <p>${note.content}</p>
      <button onclick="deleteNote('${note.noteId}')">Delete</button>
    `;

    container.appendChild(div);
  });
}

async function addNote() {
  const title = document.getElementById("title").value;
  const content = document.getElementById("content").value;

  if (!title) {
    return alert("Add a title");
  }

  await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      title,
      content
    })
  });

  document.getElementById("title").value = "";
  document.getElementById("content").value = "";

  loadNotes();
}

async function deleteNote(id) {
  await fetch(`${API_URL}/${id}`, {
    method: "DELETE"
  });

  loadNotes();
}

loadNotes();