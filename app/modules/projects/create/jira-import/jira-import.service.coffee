####
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: jira-import.service.coffee
###

class JiraImportService extends taiga.Service
    @.$inject = [
        'tgResources',
        '$location'
    ]

    constructor: (@resources, @location) ->
        @.projects = Immutable.List()
        @.projectUsers = Immutable.List()

    setToken: (token, url) ->
        @.token = token
        @.url = url

    fetchProjects: () ->
        @resources.jiraImporter.listProjects(@.url, @.token).then (projects) => @.projects = projects

    fetchUsers: (projectId) ->
        @resources.jiraImporter.listUsers(@.url, @.token, projectId).then (users) => @.projectUsers = users

    importProject: (name, description, projectId, userBindings, keepExternalReference, isPrivate, projectType, importerType) ->
            @resources.jiraImporter.importProject(@.url, @.token, name, description, projectId, userBindings, keepExternalReference, isPrivate, projectType, importerType)

    getAuthUrl: (url) ->
        return new Promise (resolve) =>
            @resources.jiraImporter.getAuthUrl(url).then (response) =>
                @.authUrl = response.data.url
                resolve(@.authUrl)

    authorize: () ->
        return new Promise (resolve, reject) =>
            @resources.jiraImporter.authorize().then ((response) =>
                @.token = response.data.token
                @.url = response.data.url
                resolve(response.data)
            ), (error) ->
                reject(new Error(error.status))

angular.module("taigaProjects").service("tgJiraImportService", JiraImportService)
