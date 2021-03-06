#### Copyright (C) 2014-2017 Jesús Espino Garcia <jespinog@gmail.com># Copyright (C) 2014-2017 Alejandro Alonso <alejandro.alonso@kaleidos.net># Copyright (C) 2014-2017 Xavi Julian <xavier.julian@kaleidos.net>
#
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
# File: modules/components/wysiwyg/comment-wysiwyg.directive.coffee
###

CommentWysiwyg = (attachmentsFullService) ->
    link = ($scope, $el, $attrs) ->
        $scope.editableDescription = false

        $scope.saveComment = (description, cb) ->
            $scope.content = ''
            $scope.vm.type.comment = description
            $scope.vm.onAddComment({callback: cb})

        types = {
            epics: "epic",
            userstories: "us",
            issues: "issue",
            tasks: "task"
        }

        uploadFile = (file, cb) ->
            return attachmentsFullService.addAttachment($scope.vm.projectId, $scope.vm.type.id, types[$scope.vm.type._name], file, true, true).then (result) ->
                cb(result.getIn(['file', 'name']), result.getIn(['file', 'url']))

        $scope.onChange = (markdown) ->
            $scope.vm.type.comment = markdown

        $scope.uploadFiles = (files, cb) ->
            for file in files
                uploadFile(file, cb)

        $scope.content = ''

        $scope.$watch "vm.type", (value) ->
            return if not value

            $scope.storageKey = "comment-" + value.project + "-" + value.id + "-" + value._name

    return {
        scope: true,
        link: link,
        template: """
            <div>
                <tg-wysiwyg
                    required
                    not-persist
                    placeholder='{{"COMMENTS.TYPE_NEW_COMMENT" | translate}}'
                    storage-key='storageKey'
                    content='content'
                    on-save='saveComment(text, cb)'
                    on-upload-file='uploadFiles(files, cb)'>
                </tg-wysiwyg>
            </div>
        """
    }

angular.module("taigaComponents")
    .directive("tgCommentWysiwyg", ["tgAttachmentsFullService", CommentWysiwyg])
