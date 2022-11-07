unit BasedOnDatabaseEmployeeApproveableDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DocumentSetHolder,
  DocumentSetHolderFactory,
  ApproveableDocumentSetHolderFactory,
  EmployeeDocumentKindAccessRightsAppService,
  EmployeeDocumentKindAccessRightsInfoDto,
  EmployeeDocumentSetHolderFactory,
  ApproveableDocumentSetHolder,
  SysUtils;

type

  TBasedOnDatabaseEmployeeApproveableDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractEmployeeDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

        procedure SetDocumentSetOperationAccessRights(
          DocumentSetHolder: TDocumentSetHolder;
          EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
        ); override;
      
    end;

  
implementation

{ TBasedOnDatabaseEmployeeApproveableDocumentSetReadService }

function TBasedOnDatabaseEmployeeApproveableDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TEmployeeDocumentSetHolderFactory.Create(
      TApproveableDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );

end;

procedure TBasedOnDatabaseEmployeeApproveableDocumentSetReadService.
  SetDocumentSetOperationAccessRights(
    DocumentSetHolder: TDocumentSetHolder;
    EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
  );
begin

  inherited SetDocumentSetOperationAccessRights(
    DocumentSetHolder, EmployeeDocumentKindAccessRightsInfoDto
  );

  DocumentSetHolder.AddingAllowed := False;

end;

end.
