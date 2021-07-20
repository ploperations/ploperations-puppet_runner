# puppet_runner

![](https://img.shields.io/puppetforge/pdk-version/ploperations/puppet_runner.svg?style=popout)
![](https://img.shields.io/puppetforge/v/ploperations/puppet_runner.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/ploperations/puppet_runner.svg?style=popout)
[![Build Status](https://github.com/ploperations/ploperations-puppet_runner/actions/workflows/pr_test.yml/badge.svg?branch=main)](https://github.com/ploperations/ploperations-puppet_runner/actions/workflows/pr_test.yml)

Deploy [puppet-runner](https://github.com/ploperations/puppet-runner) and configure puppet runs

- [Description](#description)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Limitations](#limitations)
- [Development](#development)

## Description

This module will deploy [puppet-runner](https://github.com/ploperations/puppet-runner) and schedule puppet runs that use it. puppet-runner is a wrapper for running the puppet agent that first checks that the environment an agent is configured to uses exists. If it does not then the agent is moved back to the `production` environment prior to running the puppet agent.

The scheduling is handled by the `puppet_run_scheduler` module.

## Usage

The only paramert you **need** to set is the version of [puppet-runner](https://github.com/ploperations/puppet-runner) to deploy as the default in this module may not be in sync with the latest version of the application.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via `pdk bundle exec rake changelog`. This proecss relies on labels that are applied to each pull request.

## Limitations

There are some platforms supported by the pupet agent that this module does not yet support. A workaround for this may be added later.

## Development

PRs are welcome!
