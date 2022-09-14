unit BasedOnDatabaseEmployeeInternalDocumentSetReadService;

interface

uses

  DocumentSetHolder,
  DocumentSetHolderFactory,
  InternalDocumentSetHolder,
  InternalDocumentSetHolderFactory,
  EmployeeDocumentSetHolderFactory,
  BasedOnDatabaseAbstractEmployeeDocumentSetReadService;

type

  TBasedOnDatabaseEmployeeInternalDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractEmployeeDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;
        
    end;

implementation

{ TBasedOnDatabaseEmployeeInternalDocumentSetReadService }

function TBasedOnDatabaseEmployeeInternalDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TEmployeeDocumentSetHolderFactory.Create(
      TInternalDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );

end;

end.
