# Wercker Step Hugo Build

[![wercker status](https://app.wercker.com/status/358634e8ec6ce30b40b2819ef671e273/s/master "wercker status")](https://app.wercker.com/project/byKey/358634e8ec6ce30b40b2819ef671e273)

This step will download the specified version of [Hugo](http://gohugo.io) and run this over the source code to generate the static version of your site. This can then automatically be deployed using other steps.

To speed things up, this step has the latest two versions of Hugo already installed thereby skipping the download part of the step.

## Tutorial

If you are new to Wercker, there is a full tutorial on how to use this step in combination with an automatic deployment step in the [Hugo documentation](http://gohugo.io/tutorials/automated-deployments/).

## Requirements

This step does not require any specific container.

## Breaking changes in 2.0.0

Version 2.0.0 of this step was released using Wercker's new step building system, and in doing so breaking changes were introduced.

* There is no longer support for the old (non-Docker) build system. The step might work there, or it might not. Only the Docker stack is verified to be working.
* Support for Wercker versions before 0.20.5 is no longer included. The release packages for these older versions differed in name and content. If you require support for these, please use version 1.29 of this step.
* Pygment is no longer installed by default due to the inclusion of Chroma from Hugo 0.28. If you still require Pygment you can now install it using the new `install_pygments` parameter.

## Hugo Extended Version

Starting with Hugo 0.43 there is an extended version of Hugo available that supports SASS compiling and other functionalities. Per version 2.8.0 of this step, that is the version being used when using Hugo 0.43 or higher.

## Parameters

* `version`: (optional) Specify the version of Hugo to be installed. See below for a more extensive explanation.
* `theme`: (optional) Specifies the theme to be used for the generation of the site. When this isn't defined no theme will be used.
* `config`: (optional) If you wish to use a different config file than the default `config.toml|yaml|json` you can provide the relative path and name of this file here.
* `flags`: (optional) Apart from the theme and config file, other flags can be provided as a single string. These flags will be provided exactly as set.
* `force_install`: (optional) Forces an install of Hugo, regardless of whether it is already installed in the container.
* `install_pygments`: (optional) Installs Pygments in case you don't want to use the default Chroma.
* `basedir`: (optional) Set a different directory than the root of the project as your Hugo source directory.
* `clean_before`: (optional, default true) Removes the `public` directory before build.
* `dev_flags`: (optional) Set specific flags for your development branches, overrides `flags`, `config`, `themes`.
* `prod_branches`: (optional) A space delimited list of your production git branches, all other branches will use `dev_flags`. This conflicts with `dev_branches`.
* `dev_branches`: (optional) A space delimited list of your development git branches, which will then use `dev_flags` parameters. This conflicts with `prod_branches`.

### version parameter

This parameter specifies the version of Hugo to be used, by default this is `"0.53"`. It is recommended to set this, so you don't accidentally build you site with a version it isn't ready for. Due to Wercker not being able to properly handle `0.x` version numbers, you will need to put quotes around the version number.

You can specify "HEAD" as the version, which will pull in the latest code of the Hugo `master` branch from GitHub and compile it. Please note that this means using a version of Hugo that is not released and might be unstable, so use this at your own risk.

## Example wercker.yml

```yml
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.53"
        theme: redlounge
        config: second-config.toml
        flags: --disableKinds=["sitemap"]
```
