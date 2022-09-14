unit BasedOnDatabaseDepartmentOutcomingDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  DocumentSetHolderFactory,
  DocumentSetHolder,
  OutcomingDocumentSetHolderFactory,
  DepartmentDocumentSetHolderFactory,
  SysUtils,
  Classes;
  
type

  TBasedOnDatabaseDepartmentOutcomingDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractDepartmentDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;
        
    end;
    
implementation


{ TBasedOnDatabaseDepartmentOutcomingDocumentSetReadService }

function TBasedOnDatabaseDepartmentOutcomingDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TDepartmentDocumentSetHolderFactory.Create(
      TOutcomingDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );
    
end;

end.
