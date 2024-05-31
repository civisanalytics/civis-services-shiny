# Civis Services Shiny
[![CircleCI](https://circleci.com/gh/civisanalytics/civis-services-shiny/tree/master.svg?style=svg)](https://circleci.com/gh/civisanalytics/civis-services-shiny/tree/master)

This repository provides the following components:

* A Docker Image to support R Shiny applications on Civis Platform
* A demo R Shiny app that's readily deployable on Civis Platform

## Quickstart Using the Demo Application

To get a sense of what a Shiny app looks like on Civis Platform:

* Log on to Civis Platform.
* From the top navigation bar, click "Publish".
* Under "Services", click "Shiny Demo".

These steps create a new Civis Platform service configured for a Shiny demo app pointing to this GitHub repository.
The app is now ready to be deployed.
Please follow [these instructions](https://support.civisanalytics.com/hc/en-us/articles/360001335031-Civis-Service-Deployment#StartaService/PreviewaDeployment)
for service deployment.

If you would like to start making the demo app your own by making code changes,
you may [fork this GitHub repository](https://github.com/civisanalytics/civis-services-shiny/fork)
where the demo app's source code is in the directory [`app/`](app).

If you would like to host and use your own Docker image,
[`Dockerfile`](Dockerfile) and [`entrypoint.sh`](entrypoint.sh) from this GitHub repository
define the `civisanalytics/civis-services-shiny` image that you may modify
and then host on your own DockerHub account.

## Building and Deploying Your Shiny Application

If you would like to build your own Shiny application from scratch
and deploy it on Civis Platform, here are the requirements:

1. Your Shiny application must have its source code hosted on a GitHub repository.
   The Civis Platform user account that's going to deploy this Shiny app must have
   access to this GitHub repo.
2. Your app must have either an `app.R` file _or_ `server.R` and `ui.R` files. Further file organization tips are included below.
3. Once your app code is on a GitHub repo, either create a new service on Civis Platform
   by following [this page](https://support.civisanalytics.com/hc/en-us/articles/360001335031-Civis-Service-Deployment),
   or launch a Shiny template service from Civis Platform's top navigation bar -> Publish
   -> Services -> Shiny Demo.
   Specify or adjust the GitHub repo URL as well as the Git tag (or branch, or Git commit hash).

    a. If your code is at a directory in your repo (rather than directly at the root level of your repo),
   specify the directory path that points to where the app code is located.
5. For the Docker image, the name is `civisanalytics/civis-services-shiny`,
   and the tag is one of those [listed on DockerHub](https://hub.docker.com/repository/docker/civisanalytics/civis-services-shiny/tags).
   Note that the specific Docker image name and tag you've chosen determines which R version your app is going to run on.

For more information on deploying Shiny Apps in Civis Platform, please see
[Helpful Tips for Shiny App Deployments](https://support.civisanalytics.com/hc/en-us/articles/360001338571-Shiny-App-Deployments#HelpfulTips).

### Organization Tips

As applications grow in size, a modular structure improves maintainability.
While very short applications may fit nicely in a single `app.R`, it is
recommended to use a seperate `server.R` and `ui.R` for larger projects.
For large projects, it is also recommended to keep the code in `server.R`
and `ui.R` simple by writing functions and modules in seperate R files
which are sourced at the top of the `server.R` and `ui.R` files.

#### Recommended Directory Structure

##### Basic

```
Top Level
│    README.md
│    Dockerfile
│    app.R
│    install.R
```

##### Advanced / Customized

```
Top Level
│    README.md
│    server.R
│    ui.R
│    global.R
|    install.R
│    DESCRIPTION
│    <extra_scripts>.R
│    <modules>.R
└─── www
     │    <custom_javascript>.js
     │    <custom_css>.css
     │    <custom_img>.gif

File names inside <> will change from project to project
```

#### File Structure Elements
- `README.md`
  - A description of the package and any details needed to understand and/or
    run the application.
- `app.R`
  - A single file that contains `server.R` and `ui.R`.
  - Not needed if `server.R` and `ui.R` are present.
  - See: [app format docs](https://shiny.rstudio.com/articles/app-formats.html).
- `server.R`
  - Logic for server.  The final function must be the server function.
  - See: [two-file docs](https://shiny.rstudio.com/articles/two-file.html).
- `ui.R`
  - Logic for UI elements.  The final function must be the UI object.
  - See: [two-file docs](https://shiny.rstudio.com/articles/two-file.html).
- `global.R`
  - Global logic that is run when app is started.
  - Use this file to share state across `ui.R` and `server.R`.  If only
    server needs to look at the state, prefer isolating code in `server.R`.
  - See: [scoping docs](https://shiny.rstudio.com/articles/scoping.html)
- `install.R`
  - An R script that will be run before the application is started. Used
    to install dependencies (i.e. `install.packages("somepackage")` or
    `devtools::install_github("someuser/somepackage@v1.0.0")`).
- `DESCRIPTION`
  - Mainly used to add metadata to project for Showcase mode.
  - See: [display-mode docs](https://shiny.rstudio.com/articles/display-modes.html)
- `<extra_scripts>.R`
  - Extra logic to be used in `server.R` outside the main server function.
    That is, code that is run when the application is launched and is
    accessible to all server sessions.
  - Ideally, the only code in `server.R` should be the single server function
    with a call to `source("extra_scripts.R", local=TRUE)` at the top
    of the file.
- `<modules>.R`
  - Modules to be shared across `ui.R` and `server.R`.
  - Typically, `<modules>.R` is sourced from `globals.R` with
    `source("modules.R")` so the modules can be used in both `ui.R`
    and `server.R`.
  - See: [modules docs](https://shiny.rstudio.com/articles/modules.html)
- `www`
  - Folder containing optional website elements, including javascript,
    CSS and images.

##  Use Docker Image Locally

Either build the Docker image locally
```bash
docker build -t civis-services-shiny .
```

or download the image from DockerHub
```bash
docker pull civisanalytics/civis-services-shiny:latest
```

The `latest` tag (Docker's default if you don't specify a tag)
will give you the most recently built version of the civis-services-shiny
image. You can replace the tag `latest` with a version number such as `1.0`
to retrieve a reproducible environment.

## Testing Integration with the Civis Platform

If you would like to test the image locally follow the steps below:

1. Build your image locally:
   ```
   docker build -t civis-services-shiny:test .
   ```
2. Run the container:
   ```
   docker run --rm -p 3838:3838 -e APP_DIR=/app -e CIVIS_API_KEY civis-services-shiny:test
   ```

   This mounts the `app` folder in the Docker container under `/app`, where the entrypoint expects to find it.
   You will need to modify the run command if your application is at a different path.
   It also makes the CIVIS_API_KEY environment variable accessible to the container, for initializing the Civis API client.
   However, this variable does not need to be defined in order for the app to run.

3. Visit `http://0.0.0.0:3838` to access your app.

   a. This is the default URL. The Shiny application logs should also tell you where the app is being served at.

   b. The app should also be available at the ip of your docker host with port 3838: `<docker-host-ip>:3838`.
   For example, when using Docker for Mac `<docker-host-ip>` was 127.0.0.1, so the app was available at `http://127.0.0.1:3838/`.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for information about contributing to this project.

If you make any changes, be sure to build a container to verify that it successfully completes:
```bash
docker build -t civis-services-shiny:test .
```
and describe any changes in the [change log](CHANGELOG.md).

## For Maintainers

This repo has autobuild enabled. Any PR that is merged to master will be built as the `latest` tag on Docker Hub.

### Creating a new release

Once you are ready to create a new version, go to the "releases" tab of the repository and click
"Draft a new release". Github will prompt you to create a new tag, release title, and release
description. The tag should use semantic versioning in the form "vX.X.X"; "major.minor.micro".

The title of the release should be the same as the tag. Include a change log in the release description.

Once the release is tagged, DockerHub will automatically build three identical containers, with labels
"major", "major.minor", and "major.minor.micro".

### Test branches

This repo has branch builds enabled.  Branches will be built with the tag  `dev-<branch name>` on Docker Hub.


# License

BSD-3

See [LICENSE.md](LICENSE.md) for details.
