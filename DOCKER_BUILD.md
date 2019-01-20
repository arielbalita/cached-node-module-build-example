# Purpose
Reinstall ```npm``` dependencies can be a wasteful use of time. As such, we should try and reduce how long we spend on ```npm install``` steps. We should only re-run ```npm install``` when the ```package.json``` file changes. By selectively running this we can greatly reduce the amount of time for new Gate/CI/CD builds from several minutes to less than a minute (depends on the size of your project).

In addition to caching our ```node_modules``` we are also creating a consistent build environment. This means that we can run the same build on a windows, linux, or OS X and achieve the same result.

Although the repository I have cloned is an ```angular``` project, this process is universal in it's approach.

# Process

Run the following commands in this directory

```shell
docker build -t node-build-test .
docker run -it node-build-test lint
docker run -it -v {absolute path to dir}/dist:/dist node-build-test build
```

## Explanation of each step
When you change any files always do the steps below. Otherwise you will be running your ```npm``` commands against old ```docker``` layers.
1. Build the ```docker ``` image with a tag
    ```shell
    docker build -t node-test .
    ```
2. Execute ```docker run``` against the image with the arguments being the ```npm run``` command you wish to run. *The build command should require an attached volume. See step 3 for reasoning*
    ```shell
    docker run node-test lint
    ```
3. Build the project with an attached ```dist``` volume. This is so we can capture the build output. *Please see the ```angular.json``` ```outputPath``` statement to see how we target the  ```dist``` directory. We use the sub-folder ```output``` because ```ng build``` removes the directory before running*
```shell
docker run -it -v {absolute path to dir}/dist:/dist {your_tag_name} build
``` 
