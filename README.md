<a name="readme-top"></a>

<div align="center">
  <img src="https://carapi.app/img/vehicle-api-database-hero.png" alt="logo" width="140"  height="auto" />
  <h1><b>Service Track Api</b></h1>
</div>

# 📗 Table of Contents

- [📗 Table of Contents](#-table-of-contents)
- [🎯 Service Track Api](#-service-track-api)
  - [🛠 Frontend repository: ](#-frontend-repository-)
  - [🛠 Built With ](#-built-with-)
    - [Tech Stack ](#tech-stack-)
    - [Key Features ](#key-features-)
  - [💻 Getting Started ](#-getting-started-)
    - [Prerequisites](#prerequisites)
    - [Clone Repository](#clone-repository)
    - [Add necessary packages](#add-necessary-packages)
    - [Setup Database locally](#setup-database-locally)
    - [Run the server in development mode](#run-the-server-in-development-mode)
    - [Run the test](#run-the-test)
  - [👥 Authors ](#-authors-)
    - [First Author:](#first-author)
  - [🤝 Contributing ](#-contributing-)
  - [👋 Show your support ](#-show-your-support-)
  - [📝 License ](#-license-)

<!-- PROJECT DESCRIPTION -->

# 🎯 Service Track Api<a name="about-project"></a>

This API enables you to manage vehicle maintenance records. It allows you to create and delete both vehicles and their corresponding maintenance entries. The API offers filtering capabilities, enabling you to search for maintenance records based on status and license plate number.

To access the full functionality of the API, including the CRUD operations, you must first create a user account. Afterward, a token needs to be generated and used for authentication in all subsequent requests.

## 🛠 Frontend repository: <a name="frontend"></a>

To visit the frontend repository, please [click here](https://github.com/sambeck87/service-track-app).

## 🛠 Built With <a name="built-with"></a>

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Technology</summary>
  <ul>
    <li>Ruby</li>
    <li>Rails</li>
    <li>PostgresSQL</li>
    <li>JWT</li>
    <li>MiniTest</li>
  </ul>
</details>

<details>
  <summary>Tools</summary>
  <ul>
    <li>VS Code</li>
    <li>Git</li>
    <li>GitHub</li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

Main functionalities which the app will have:

- **User creation:** Allows create new users.
- **Token Generator:** Allows generate a token to use this API.
- **Car CRUD:** This API provides endpoints for managing car records, including creation, reading, updating, and deletion. Key features include:
* Unique plate number constraint: Ensures that each car record has a unique plate number.
* Flexible data retrieval: Supports querying for specific vehicles based on various criteria, as well as retrieving a complete list of all cars.
- **Maintenance Service CRUD:** A CRUD is also implemented to store the maintenance performed per vehicle. You can create, update and delete records. You can request the list of vehicles, which can be filtered by number plate and/or maintenance status.
- **Postman Collection:** [Link to get the postman collection.](https://drive.google.com/file/d/1uNmHldhPdEFjxCfV4HuawGuLHAcZS9hV/view?usp=sharing)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running follow these simple example steps.

### Prerequisites

you have to those tools in your local machine.

- [ ] Ruby
- [ ] Rails
- [ ] PostgresSQL
- [ ] Git & GitHub
- [ ] Any Code Editor (VS Code, Brackets, etc)

### Clone Repository

Clone the repository using the following bash command in an appropriate location.

```bash
  git clone git@github.com:sambeck87/service-track-API.git
```

Go to the project directory.

```bash
  cd service-track-API
```

### Add necessary packages

For installing necessary packages, run the following bash command:

```bash
  bundle install
```

### Setup Database locally

For setup database locally, run the following bash commands:

- Create a database in your local machine

```bash
  rails db:create
```

- Run necessary migrations

```bash
  rails db:migrate
```

### Run the server in development mode

In the project directory, you can run the project by using following bash command:

```bash
  rails s
```

And now you can use the the URL http://localhost:3000 to use the API

### Run the test

```bash
  rails test
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

### First Author:

**Sandro Hernandez**

[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://sambeck87.github.io/Portfolio/) [![linkedin](https://img.shields.io/badge/sandro_israel_hernández_zamora-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sandro-israel-hern%C3%A1ndez-zamora/) [![twitter](https://img.shields.io/badge/@sambeck4488-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/sambeck4488)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](../../../issues/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->

## 👋 Show your support <a name="support"></a>

Give a ⭐️ if you like this project!


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
