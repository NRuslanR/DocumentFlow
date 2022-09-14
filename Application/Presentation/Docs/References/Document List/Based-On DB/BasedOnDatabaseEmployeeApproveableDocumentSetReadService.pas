unit BasedOnDatabaseEmployeeApproveableDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DocumentSetHolder,
  DocumentSetHolderFactory,
  ApproveableDocumentSetHolderFactory,
  EmployeeDocumentKindAccessRightsService,
  EmployeeDocumentKindAccessRightsInfo,
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
          EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
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
    EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
  );
begin

  inherited SetDocumentSetOperationAccessRights(
    DocumentSetHolder, EmployeeDocumentKindAccessRightsInfo
  );

  DocumentSetHolder.AddingAllowed := False;

end;

end.
