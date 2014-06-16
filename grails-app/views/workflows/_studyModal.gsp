<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" >
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel"></h4>
            </div>
            <div class="modal-body">

                <table class="table" width="100%">
                    <tr>
                        <td class="label-bis" width="20%"><g:message code="study.longName"/></td>
                        <td id="studyTitle"></td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.patients"/></td>
                        <td id="studyPatients" ></td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.biospecimen"/></td>
                        <td id="studyBiospecimen" ></td>
                    </tr>
                    <tr>
                        <td class="label-bis" ><g:message code="study.abstract"/></td>
                        <td id="studyAbstract" ></td>
                    </tr>

                </table>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="selectStudy">Select Study</button>
            </div>
        </div>
    </div>
</div>