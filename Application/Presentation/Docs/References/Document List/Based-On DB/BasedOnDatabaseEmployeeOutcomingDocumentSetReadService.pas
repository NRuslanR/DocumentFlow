unit BasedOnDatabaseEmployeeOutcomingDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DocumentSetHolder,
  OutcomingDocumentSetHolderFactory,
  EmployeeDocumentSetHolderFactory,
  DocumentSetHolderFactory,
  OutcomingDocumentSetHolder,
  EmployeeDocumentKindAccessRightsService,
  AbstractDocumentSetHolderDecorator,
  DB,
  SysUtils;

type

  TBasedOnDatabaseEmployeeOutcomingDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractEmployeeDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

    end;
    
implementation


{ TBasedOnDatabaseEmployeeOutcomingDocumentSetReadService }

function TBasedOnDatabaseEmployeeOutcomingDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin
      
  Result :=
    TEmployeeDocumentSetHolderFactory.Create(
      TOutcomingDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );
    
end;

end.
