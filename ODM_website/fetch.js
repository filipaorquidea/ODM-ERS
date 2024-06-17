async function fetchProjectsJSON() {
    const response = await fetch('https://api.cosmicjs.com/v3/buckets/odm-production/objects?pretty=true&query=%7B%22type%22:%22obras%22%7D&limit=112&skip=0&read_key=3fygwXY2K9KX0vuwGSRQVoYqMegy89dC5yROT4y1gIQvFq0Qez&depth=1&props=slug,title,metadata,', 'https://api.cosmicjs.com/v3/buckets/odm-production/objects?pretty=true&query=%7B%22type%22:%22lojas%22%7D&limit=10&read_key=3fygwXY2K9KX0vuwGSRQVoYqMegy89dC5yROT4y1gIQvFq0Qez&depth=1&props=slug,title,metadata,');
    const projects = await response.json();
    return projects.objects;
  }

  fetchProjectsJSON().then(projects => {
    console.log(projects);

    for (let i = 0; i < projects.length; i++) {
       object = document.createElement("object");
       console.log(projects[i].slug);
       p.innerHTML = "<a href=\"objeto.html?id="+projects[i].id+"\">"+projects[i].slug+"</a>";
       document.body.appendChild(object);
    }
  });