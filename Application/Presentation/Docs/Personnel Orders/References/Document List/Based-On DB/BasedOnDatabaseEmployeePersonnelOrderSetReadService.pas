unit BasedOnDatabaseEmployeePersonnelOrderSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DocumentSetHolder,
  DocumentSetHolderFactory,
  PersonnelOrderSetHolderFactory,
  EmployeeDocumentSetHolderFactory,
  SysUtils;

type

  TBasedOnDatabaseEmployeePersonnelOrderSetReadService =
    class (TBasedOnDatabaseAbstractEmployeeDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

    end;
    
implementation

uses

  SelectDocumentRecordsViewQueries;

{ TBasedOnDatabaseEmployeePersonnelOrderSetReadService }

function TBasedOnDatabaseEmployeePersonnelOrderSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TEmployeeDocumentSetHolderFactory.Create(
      TPersonnelOrderSetHolderFactory.Create
    );

end;

end.
