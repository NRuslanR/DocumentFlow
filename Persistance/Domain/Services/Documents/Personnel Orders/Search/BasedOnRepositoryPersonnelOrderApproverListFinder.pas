unit BasedOnRepositoryPersonnelOrderApproverListFinder;

interface

uses

  BasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderSubKindEmployeeListRepository,
  AbstractPersonnelOrderApproverListFinder,
  PersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderEmployeeList,
  PersonnelOrderApproverList;

type

  TBasedOnRepositoryPersonnelOrderApproverListFinder =
    class (TAbstractPersonnelOrderApproverListFinder)

      private

        FBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder:
          TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder;

        Free: IPersonnelOrderSubKindEmployeeListFinder;
        
      public

        constructor Create(
          PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
        );
        
        function FindPersonnelOrderEmployeeList(const EmployeeListId: Variant): TPersonnelOrderEmployeeList; override;
         
    end;

implementation

{ TBasedOnRepositoryPersonnelOrderApproverListFinder }

constructor TBasedOnRepositoryPersonnelOrderApproverListFinder.Create(
  PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
);
begin

  inherited Create;

  FBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder :=
    TBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder.Create(
      PersonnelOrderSubKindEmployeeListRepository
    );

  Free := FBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder;
  
end;

function TBasedOnRepositoryPersonnelOrderApproverListFinder.FindPersonnelOrderEmployeeList(
  const EmployeeListId: Variant): TPersonnelOrderEmployeeList;
begin

  Result :=
    FBasedOnRepositoryPersonnelOrderSubKindEmployeeListFinder
      .FindPersonnelOrderEmployeeList(EmployeeListId) as TPersonnelOrderApproverList;
      
end;

end.
