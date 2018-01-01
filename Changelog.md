
1.25.0 / 2018-01-01
==================

 * Update Hugo default to 0.32

1.24.0 / 2017-11-28
==================

 * Update Hugo default to 0.31.1

1.23.3 / 2017-11-03
==================

 * Ensure there is a content directory available, as per #42

1.23.2 / 2017-10-20
==================

 * Update Hugo default to 0.30.2

1.23.1 / 2017-10-19
==================

 * Update Hugo default to 0.30.1

1.23.0 / 2017-10-17
==================

 * Update Hugo default to 0.30

1.22.0 / 2017-09-30
==================

 * Update Hugo default to 0.29

1.21.1 / 2017-09-15
==================

  * Update Hugo version to 0.27.1

1.21.0 / 2017-09-12
==================

 * Update Hugo default to 0.27

1.20.0 / 2017-08-20
==================

 * Update Hugo default to 0.26
 * Make it easier to update included Hugo versions in wercker.yml

1.19.0 / 2017-06-25
==================

 * Update Hugo default to 0.24.1

1.18.0 / 2017-06-17
==================

 * Update Hugo default to 0.23 (thanks to [sigma](https://github.com/sigma))
 * Update the Hugo GitHub organization to gohugoio (thanks to [sigma](https://github.com/sigma))

1.17.0 / 2017-05-30
==================

  * Update Hugo default to 0.21

1.16.3 / 2017-04-30
==================

  * make 0.20.6 the default (thanks to [sigma](https://github.com/sigma))
  * fix hugo command location (thanks to [sigma](https://github.com/sigma))

1.16.2 / 2017-04-18
==================

  * Update default to Hugo 0.20.2

1.16.1 / 2017-04-16
==================

  * Update default to Hugo 0.20.1

1.16.0 / 2017-04-11
==================

  * Update default to Hugo 0.20

1.15.2 / 2017-04-02
==================

  * Automatically clean the public directory before running

1.15.1 / 2017-03-03
==================

  * Set the actual correct default

1.15.0 / 2017-03-03
==================

 * Update to version 0.19

1.14.1 / 2017-01-04
==================

  * Update to version 0.18.1

1.14.0 / 2016-12-28
==================

  * Compatibility for 0.18
  * Merge pull request #29 from jrbasso/patch-1
  * Update README to use more recent versions

1.13.1 / 2016-10-11
==================

  * The filestructure for 0.17 was different than expected

1.13.0 / 2016-10-11
==================

  * Add support for 0.17 and make it the default

1.12.1 / 2016-09-26
==================

  * Make sure to update apk sources

1.12.0 / 2016-09-23
==================

 * Add support for Alpine (thanks to [alrayyes](https://github.com/alrayyes))

1.11.0 / 2016-08-06
==================

  * Add support for changing source directory (thanks to [philhug](https://github.com/philhug) and [sword42](https://github.com/sword42))

1.10.1 / 2016-06-09
==================

  * Default to Hugo 0.16

1.10.0 / 2016-06-08
===================

 * Fix for version 0.16's different filename
 * Store 0.16 in the step

1.9.2 / 2016-05-05
==================

  * Fix pygments being installed when not wanted

1.9.1 / 2016-05-05
==================

  * Ensure Curl is always installed

1.9.0 / 2016-05-05
==================

  * If a Hugo version is stored in the step, use that
  * Store Hugo versions in the step

1.8.3 / 2016-03-05
==================

 * Install correct pygments on Debian. Fixes #22

1.8.2 / 2016-01-18
==================

 * Copy everything to the output dir

1.8.1 / 2015-12-06
==================

 * Use sudo for package install when possible

1.8.0 / 2015-11-30
==================

 * Support for using Hugo HEAD. Fixes #15

1.7.0 / 2015-11-30
==================

 * Default to using Hugo 0.15

1.6.2 / 2015-11-30
==================

 * Bugfix: Disable Pygments flag works correctly. Fixes #16

1.6.1 / 2015-09-08
==================

  * Bugfix: branch checking logic (provided by [SamuelDeBruyn](https://github.com/SamuelDebruyn))

1.6.0 / 2015-09-06
==================

  * Add support for different flags on different branches (provided by [SamuelDeBruyn](https://github.com/SamuelDebruyn))
  * Add support for pygments and pacman (provided by [SamuelDeBruyn](https://github.com/SamuelDebruyn))
  * Add parameter disable_python (provided by [SamuelDeBruyn](https://github.com/SamuelDebruyn))

1.5.0 / 2015-08-28
==================

  * Only install hugo if explicitly requested or if hugo is not already installed (provided by [SamuelDeBruyn](https://github.com/SamuelDebruyn))

1.4.1 / 2015-06-08
==================

 * Add warning and default to latest for incorrect version

1.4.0 / 2015-06-08
==================

 * Improve documentation for Docker workflow
 * Use curl instead of wget

1.3.0 / 2015-05-27
==================

 * Upgrade to 0.14 by default

1.2.0 / 2015-04-25
==================

 * Support the config flag

1.1.1 / 2015-04-24
==================

 * Upgrade to 0.13 by default (provided by [Fale](https://github.com/Fale))

1.1.0 / 2015-03-01
==================

 * Update README for new version
 * Change default Hugo version and update step version

1.0.2 / 2015-01-08
==================

 * Fix flags and themes not working well

1.0.0 / 2015-01-03
==================

 * Initial version
