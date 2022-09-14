unit BasedOnDatabaseDepartmentPersonnelOrderSetReadService;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  DepartmentDocumentSetHolderFactory,
  DocumentSetHolderFactory,
  PersonnelOrderSetHolderFactory,
  SysUtils;

type

  TBasedOnDatabaseDepartmentPersonnelOrderSetReadService =
    class (TBasedOnDatabaseAbstractDepartmentDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;
      
    end;

implementation

{ TBasedOnDatabaseDepartmentPersonnelOrderSetReadService }

function TBasedOnDatabaseDepartmentPersonnelOrderSetReadService.CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TDepartmentDocumentSetHolderFactory.Create(
      TPersonnelOrderSetHolderFactory.Create
    );
    
end;

end.
