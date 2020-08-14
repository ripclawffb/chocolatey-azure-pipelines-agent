﻿# Azure Pipelines Agent Chocolatey Package

[![Build status](https://ci.appveyor.com/api/projects/status/212o030mcfk3c3lj/branch/master?svg=true)](https://ci.appveyor.com/project/ripclawffb/chocolatey-azure-pipelines-agent/branch/master)

To build and deploy Windows, Azure, and other Visual Studio solutions you'll need at least one Windows agent. Windows agents can also build Java and Android apps.

**Please Note**: This is an automatically updated package. If you find it is 
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.

## Package Specific

### Package Parameters

The following package parameters can be set:

To configure an agent, it must know the URL to your organization or collection and credentials of someone authorized to set up agents. All other responses are optional.

#### Required options
* url <url> - URL of the server. For example: https://dev.azure.com/myorganization or http://my-azure-devops-server:8080/tfs
* auth <type> - authentication type. Valid values are:
    * pat (Personal access token)
    * negotiate (Kerberos or NTLM)
    * alt (Basic authentication)
    * integrated (Windows default credentials)

#### Authentication options

If you chose --auth pat:

* token <token> - specifies your personal access token

If you chose --auth negotiate or --auth alt:

* userName <userName> - specifies a Windows username in the format domain\userName or userName@domain.com
* password <password> - specifies a password

#### Pool and agent names

* pool <pool> - pool name for the agent to join
* agent <agent> - agent name
* replace - replace the agent in a pool. If another agent is listening by the same name, it will start failing with a conflict
  
#### Agent setup

* work <workDirectory> - work directory where job data is stored. Defaults to _work under the root of the agent directory. The work directory is owned by a given agent and should not share between multiple agents.
* acceptTeeEula - accept the Team Explorer Everywhere End User License Agreement (macOS and Linux only)
* disableloguploads - don't stream or send console log output to the server. Instead, you may retrieve them from the agent host's filesystem after the job completes.

#### Windows-only startup

* runAsService - configure the agent to run as a Windows service (requires administrator permission)
* runAsAutoLogon - configure auto-logon and run the agent on startup (requires administrator permission)
* windowsLogonAccount <account> - used with --runAsService or --runAsAutoLogon to specify the Windows user name in the format domain\userName or userName@domain.com
* windowsLogonPassword <password> - used with --runAsService or --runAsAutoLogon to specify Windows logon password
* overwriteAutoLogon - used with --runAsAutoLogon to overwrite the existing auto logon on the machine

#### Deployment group only

* deploymentGroup - configure the agent as a deployment group agent
* deploymentGroupName <name> - used with --deploymentGroup to specify the deployment group for the agent to join
* projectName <name> - used with --deploymentGroup to set the project name
* addDeploymentGroupTags - used with --deploymentGroup to indicate that deployment group tags should be added
* deploymentGroupTags <tags> - used with --addDeploymentGroupTags to specify the comma separated list of tags for the deployment group agent - for example "web, db"

To pass parameters, use `--params "''"` (e.g. `choco install packageID [other options] --params="'/ITEM:value /ITEM2:value2 /FLAG_BOOLEAN'"`).

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.
