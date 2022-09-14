unit BasedOnDatabaseDepartmentIncomingDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  DocumentSetHolderFactory,
  DepartmentDocumentSetHolderFactory,
  IncomingDocumentSetHolderFactory,
  DocumentSetHolder,
  SysUtils,
  Classes;

type

  TBasedOnDatabaseDepartmentIncomingDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractDepartmentDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

    end;

implementation

{ TBasedOnDatabaseDepartmentIncomingDocumentSetReadService }

function TBasedOnDatabaseDepartmentIncomingDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TDepartmentDocumentSetHolderFactory.Create(
      TIncomingDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );
    
end;

end.
