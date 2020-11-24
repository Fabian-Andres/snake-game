# snake-game

Classic snake game created with Phaser (game framework) Vue, Golang and CockroachDB.

## System requirements

-  [Phaser](https://phaser.io/ "Phaser").
-  [Vue](https://vuejs.org/ "Vue").
-  [Golang](https://golang.org/ "Golang").
-  [CockroachDB](https://www.cockroachlabs.com/ "CockroachDB").
-  [Npm](https://www.npmjs.com/ "Npm") or [Yarn](https://yarnpkg.com/en/ "Yarn").

## Installation

To carry out the installation of the project, the following steps must be carried out:

### Clone Repository.

To clone the application, run this command on your terminal:

    git clone https://github.com/Fabian-Andres/snake-game.git


### Configure and download dependencies
First configure and start the database, go to `cd /snake-game/api/score/storage` and read the file `cockroachDB.config` follow the steps to start your database.

### API:

Being in  `cd /snake-game/api/score`

- Start the API with.

```
$ go run router/main.go
```

Now we have our application running on the route:

```
http://localhost:3000/api
```

Endpoint.

- /scores

### Requests of the api Rest:

If you like can use **Postman** to populate the database:

**Add a score** `method: POST`

```
http://localhost:3000/api/scores
```

We insert our JSON and send.

```
{
    "nickname": "Anonymous",
    "total_score": 4500
}
```

**Get all scores** `method: GET`

```
http://localhost:3000/api/scores
```
 
And send.

### FrontEnd:

Being in  `cd /snake-game/web-app`

- Install all the dependencies of the package control of the application.

```
$ npm install
```

- Compile the application in the development environment.

```
$ npm start
```
- Compile the application in the production environment.

```
$ npm run build
```

Finally enjoy the game!

## Author

Fabian Andres Riascos @fabian-andres