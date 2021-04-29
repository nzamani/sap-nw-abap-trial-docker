# SAP NW ABAP 7.52 SP01 Trial in Docker

**UPDATE:** Meanwhile, SAP has published a Docker Image, for details see [SAP ABAP Platform 1909, Developer Edition: AVAILABLE NOW](https://blogs.sap.com/2021/02/15/sap-abap-platform-1909-developer-edition-available-soon/). SAP's official Docker Image is the preferred way to get the latest ABAP Dev Edition up and running easily.

Useful for setting up a local ABAP for own education. Not intended for production. After all, we're putting a fat monolith into Docker. However, using Docker still allows you to keep your host system clean of all the mess any installation can cause.

See my YouTube video for additional details: [Installing SAP NW ABAP 7.51 SP02 into Docker](https://www.youtube.com/watch?v=H0GEg8r7P48)

Check also my blog [Installing SAP NW ABAP into Docker](https://blogs.sap.com/2018/05/30/installing-sap-nw-abap-into-docker/). There you'll find links to the whole blog series.

**HINTS:**

- Looking for NW ABAP 7.51 SP02? See [branch nw-abap-7.51](https://github.com/nzamani/sap-nw-abap-trial-docker/tree/nw-abap-7.51)

For additional details about NW ABAP 7.52 SP04 see the [official SAP announcement by Julie Plummer](https://blogs.sap.com/2019/07/01/as-abap-752-sp04-developer-edition-to-download/).

## Attribution

The Dockerfile is based on:

- [This Dockerfile by Gregor Wolf](https://bitbucket.org/gregorwolf/dockernwabap750/src/25ca7d78266bef8ed41f1373801fd5e63e0b9552/Dockerfile?at=master&fileviewer=file-view-default)
- [This Dockerfile by Tobias Hofmann](https://github.com/tobiashofmann/sap-nw-abap-docker/blob/master/Dockerfile)

## Instructions

1. Install [Docker](https://www.docker.com/community-edition)

1. Increase the `Disc Image Size` in your Docker preferences
    - Just add 100 GB to the existing value :-)
    - You may want to increase the `Memory` in Docker's advanced settings (I chose `6 GiB`)

    **IMPORTANT:** if you skip this step you may get an error during installation!

1. Set **vm.max_map_count** to avoid intsallation error

    For **NW ABAP 7.52** the installation tries to set **vm.max_map_count** in case it assumes it's value is too low. However, if that's the case you'll get an error similar to **sysctl: setting key "vm.max_map_count": Read-only file system**. So before starting the installation it’s important to set the value for **vm.max_map_count** to something equal to or higher than what the installation needs, otherwise the installation will try to increase the value and you’ll get the same error again and again... For me the value 1000000 worked just fine. Here is how you can change the value:

    - Linux:

        ```sh
        sysctl -w vm.max_map_count=1000000
        ```

    - macOS wit Docker for Mac (FYI see also here):

        ```sh
        screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty
        sysctl -w vm.max_map_count=1000000
        ```

    - Windows and macOS with Docker Toolbox

        ```sh
        docker-machine ssh
        sudo sysctl -w vm.max_map_count=1000000
        ```

    Finally, check via `sysctl vm.max_map_count` and exit via `crtl+a` and `ctrl+d`.

    For additional details see [here](https://www.elastic.co/guide/en/elasticsearch/reference/master/docker.html#docker-cli-run-prod-mode), [here](https://deployeveryday.com/2016/09/23/quick-tip-docker-xhyve.html), and [SAP Note 900929](https://launchpad.support.sap.com/#/notes/900929) which even recommends to use the maximum possible value of 2147483647 **for the sake of simplicity** (in a slightly different context).

1. Install [Git](https://git-scm.com)

    On Windows I suggest to install Git Bash as well (you'll be asked during the installation process).

    **Hint:** Installing git is actually not really needed. Alternatively, you could also copy/download this Dockerfile etc. to your machine.

1. Clone this repo

    ```sh
    git clone https://github.com/nzamani/sap-nw-abap-trial-docker.git
    cd sap-nw-abap-trial-docker
    ```

1. Download [SAP NW ABAP 7.52 SP01 Trial from SAP](https://developers.sap.com/germany/trials-downloads.html) (search for **7.52**), then:
    - create a folder `sapdownloads` inside the clone
        - `mkdir sapdownloads`
    - extract the downloaded rar files into the folder we just created (just extract the first rar file), i.e. assuming you have unrar installed (else use your tool of choice)
        - `unrar x TD752SP01.part01.rar ./sapdownloads`

    **Hint:** SAP wants to know who downloads the NW ABAP Trial version. Thus, you will have to logon with your own account before you can start the download. Creating an account is free, so is the download. The account can be the same account you use for the SAP Communitiy / SCN.

1. Build the Docker image

    - Without Proxy

        ```sh
        docker build -t nwabap:7.52 .
        ```

    - Behind a Proxy

        ```sh
        docker build --build-arg http_proxy=http://proxy.mycompany.corp:1234 --build-arg https_proxy=http://proxy.mycompany.corp:1234 -t nwabap:7.52 .
        ```

        **Hint:** In a proxy environment your `docker build` command (see above) will fail in case you don't set the proxy as mentioned above or in case you use wrong proxy settings. Also consider that you might have to set the proxy manually for some software installed in the container.

1. Create/Start a container with one of the following commands:

    - Use this if you want to map the default SAP ports as they come on localhost (preferred)

        ```sh
        docker run -p 8000:8000 -p 44300:44300 -p 3300:3300 -p 3200:3200 -h vhcalnplci --name nwabap752 -it nwabap:7.52 /bin/bash
        ```

    - Use this one if "random" ports on localhost are fine for you

        ```sh
        docker run -P -h vhcalnplci --name nwabap752 -it nwabap:7.52 /bin/bash
        ```

    **Hint:** You could also use `--rm` to make the container is removed after you exit your cli/terminal, i.e.:

      ```sh
      docker run -p 8000:8000 -p 44300:44300 -p 3300:3300 -p 3200:3200 -h vhcalnplci --rm --name nwabap752 -it nwabap:7.52 /bin/bash
      ```

1. Now start the installation of SAP NW ABAP 7.52 Trial

    - Auto install via Expect script (suggested for simplicity)

        ```sh
        /usr/sbin/uuidd
        ./install.exp
        ```

    - Or the standard way

        ```sh
        /usr/sbin/uuidd
        ./install.sh
        ```

    Your installation has been successful if you see the followong message: **Installation of NPL successful**

    **Hint:** This installation will take about 20-30 minutes. Once done your SAP is running. Next, stop the system and exit the container.

## Starting and Stopping the NW ABAP 7.52 Trial

1. Starting the container + SAP NW ABAP Trial (use this from now on instead of `docker run ...` from above)

    ```sh
    docker start -i nwabap752
    /usr/sbin/uuidd
    su npladm
    startsap ALL
    ```

1. Stopping SAP NW ABAP Trial and container (`ALL` can be omitted)

    ```sh
    su npladm
    stopsap ALL
    exit
    exit
    ```

    **Hint:** After the second `exit` the Docker container is stopped.

## Important Post Installation Steps

1. Updating License

    - Open SAP GUI and logon
        - **User:** SAP*
        - **Password:** Down1oad
        - **Client:** 000

    - Open Transaction `SLICENSE`
    - From the Screen copy the value of field `Active Hardware Key`
    - Go to [SAP License Keys for Preview, Evaluation, and Developer Versions](https://go.support.sap.com/minisap/#/minisap) in your browser
    - Choose `NPL - SAP NetWeaver 7.x (Sybase ASE)`
    - Fill out the fields. Use the `Hardware Key` you copied from `SLICENSE`
    - Keep the downloaded file `NPL.txt` and go back to the `SLICENSE`
    - Delete the `Installed License` from the table
    - Press the button `Install` below the table
    - Choose the downloaded file `NPL.txt`
    - Done - happy learning. Now logon with the dev user.

    You can now logon to `client 001` with any of the following users (all share the same password `Down1oad`, typically you would work with `DEVELOPER`):

      - **User:** DEVELOPER (Developer User)
      - **User:** BWDEVELOPER (Developer User)
      - **User:** DDIC (Data Dictionary User)
      - **User:** SAP* (SAP Administrator)

1. Generating Test Data

    Execute the following to generate some test data:

      - **Report:** SAPBC_DATA_GENERATOR
      - **Transaction Code:** SEPM_DG

1. Suggestion: Activate the good old ping service

    - Go to Transaction `SICF`
    - Activate the node `/sap/public/ping` (default_host)
    - Test the HTTP and HTTPS connection with your browser

        - **HTTP:**  [http://localhost:8000/sap/public/ping](http://localhost:8000/sap/public/ping)
        - **HTTPS:** [https://localhost:44300/sap/public/ping](https://localhost:44300/sap/public/ping)

## Logfiles

Assuming you have started your container (not necessarily the NW ABAP in the container) and switched to user `npladm`:

  ```sh
  docker start -i nwabap752
  /usr/sbin/uuidd
  su npladm
  ```

Afterwards, type `alias` to see some shortcuts SAP has created for us:

  ```sh
  alias
  ```

One of them is `cdDi` which you can execute in you CLI:

  ```sh
  cdDi
  ```

Then, after hitting `ls -ahl` you know there is a directory `work`:

  ```sh
  cd work
  ```

This folder contains important log files for us, i.e. `dev_icm` and `dev_w0`:

  ```sh
  vi dev_icm
  vi dev_w0
  ```

Check their content (i.e. with vi) in case you're facing issues with your NW ABAP which you can't explain. For example, in case your NW ABAP has started successfully, but you cannot access the ping service via HTTP/HTTPS, you might find an issue in one of these files.
