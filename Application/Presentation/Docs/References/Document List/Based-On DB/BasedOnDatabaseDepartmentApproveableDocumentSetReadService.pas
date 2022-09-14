unit BasedOnDatabaseDepartmentApproveableDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  ApproveableDocumentSetHolderFactory,
  DepartmentDocumentSetHolderFactory,
  DocumentSetHolderFactory,
  SysUtils;

type

  TBasedOnDatabaseDepartmentApproveableDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractDepartmentDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

    end;

  

implementation

{ TBasedOnDatabaseDepartmentApproveableDocumentSetReadService }

function TBasedOnDatabaseDepartmentApproveableDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TDepartmentDocumentSetHolderFactory.Create(
      TApproveableDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );
  
end;

end.
