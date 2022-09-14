unit BasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService;

interface

uses

  BasedOnDatabaseDocumentCreatingDefaultInfoReadService,
  EmployeeFinder,
  EmployeeSubordinationService,
  AbstractQueryExecutor,
  PersonnelOrderSignerListFinder,
  PersonnelOrderSignerList,
  Employee,
  SysUtils;
  
type

  TBasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService =
    class (TBasedOnDatabaseDocumentCreatingDefaultInfoReadService)

      private

        FPersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;
        
      protected

        function GetDefaultDocumentSignerForEmployee(const EmployeeId: Variant): TEmployee; override;

      public

        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          EmployeeSubordinationService: IEmployeeSubordinationService;
          QueryExecutor: TAbstractQueryExecutor;
          QueryBuilder: TDocumentCreatingDefaultInfoFetchingQueryBuilder;
          PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder
        );
        
    end;

implementation

uses

  Variants,
  IDomainObjectBaseUnit;
  
{ TBasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService }

constructor TBasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService.Create(
  EmployeeFinder: IEmployeeFinder;
  EmployeeSubordinationService: IEmployeeSubordinationService;
  QueryExecutor: TAbstractQueryExecutor;
  QueryBuilder: TDocumentCreatingDefaultInfoFetchingQueryBuilder;
  PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder
);
begin

  inherited Create(
    EmployeeFinder,
    EmployeeSubordinationService,
    QueryExecutor,
    QueryBuilder
  );

  FPersonnelOrderSignerListFinder := PersonnelOrderSignerListFinder;

end;

function TBasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService.
  GetDefaultDocumentSignerForEmployee(
    const EmployeeId: Variant
  ): TEmployee;
var
    PersonnelOrderSignerList: TPersonnelOrderSignerList;
    Free: IDomainObjectBase;
begin

  PersonnelOrderSignerList := FPersonnelOrderSignerListFinder.FindPersonnelOrderSignerList;

  if
    Assigned(PersonnelOrderSignerList)
    and not VarIsNull(PersonnelOrderSignerList.DefaultSignerId)
  then
    Result := FEmployeeFinder.FindEmployee(PersonnelOrderSignerList.DefaultSignerId)

  else Result := nil;
  
end;

end.
