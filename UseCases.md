
Use case name        | Create model
------------         | -------------
Participating actors | Website visitor
Entry conditions     | <ul><li>Website must have a stable connection to server to generate the model</li><li>Must have sufficient variables to generate a model of</li>
Exit conditions      | Model must be showing on the website
Flow of events       | <ol><li>The actor selects a model and sets the variables available</li><li>The actor clicks a button intending to load the model to their screen</li><li>NetLogo Web is run and the website waits for a response containing the model</li><li>The model is returned and displayed onto the initial webpage</li></ol>
Error scenario       | <ul><li>If clicking the button generates no response a timeout generates an error message is shown (indicating the problem if possible)</li><li>The flow of events could be interrupted if the netLogo Web fails to respond</li></ul>
  
**Use case summary** - This use case describes the key interaction between the user and our software, as planned from the start of the project, and described an abstract core functionality of the software.



Use case name        | Upload custom model
------------         | -------------
Participating actors | Developer
Entry conditions     | Stable connection to the website server
Exit conditions      | <ul><li>Model is uploaded to the server and a confirmation is received at the browser</li><li>Must have sufficient variables to generate a model of</li>
Flow of events       | <ol><li>The developer clicks a button indicating they wish to add a model to the list of available models</li><li>The browser lets the user select a file to upload</li><li>The user sends the model to the server</li></ol>
Error scenario       | <ul><li>If no acknowledgement is received from the server when the model is sent, a timeout indicates a problem and tries to identify the issue</li><li>If error(s) are detected in the model when it is run online, the developer is notified and the model is not added to the repository of models</li></ul>
  
**Use case summary** - This use case describes what was an optional functionality, but was not fulfilled at the time of writing this.
