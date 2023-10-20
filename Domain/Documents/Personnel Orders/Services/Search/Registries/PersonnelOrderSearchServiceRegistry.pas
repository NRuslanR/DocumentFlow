unit PersonnelOrderSearchServiceRegistry;

interface

uses

  TypeObjectRegistry,
  PersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSubKindEmployeeListFinder,
  PersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderEmployeeList,
  PersonnelOrderApproverList,
  PersonnelOrderSignerList,
  PersonnelOrderControlGroup,
  PersonnelOrderCreatingAccessEmployeeList,
  PersonnelOrderSubKindEmployeeList,
  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderControlGroupFinder,
  PersonnelOrderApproverListFinder,
  PersonnelOrderSignerListFinder,
  PersonnelOrderCreatingAccessEmployeeListFinder,
  PersonnelOrderSubKindFinder,
  SysUtils;

type

  TPersonnelOrderSearchServiceRegistry = class

    private

      FPersonnelOrderSubKindFinder: IPersonnelOrderSubKindFinder;
      FSingleEmployeeListFinderRegistry: TTypeObjectRegistry;
      FSubKindEmployeeListFinderRegistry: TTypeObjectRegistry;
      FSubKindEmployeeGroupFinderRegistry: TTypeObjectRegistry;
      
      class var FInstance: TPersonnelOrderSearchServiceRegistry;

      class function GetInstance: TPersonnelOrderSearchServiceRegistry; static;

      class procedure SetInstance(
        const Value: TPersonnelOrderSearchServiceRegistry
      ); static;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterPersonnelOrderCreatingAccessEmployeeFinder(
        PersonnelOrderCreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder
      );

      function GetPersonnelOrderCreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder;

    public

      procedure RegisterPersonnelOrderSignerListFinder(
        PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder
      );

      function GetPersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;

    public

      procedure RegisterPersonnelOrderApproverListFinder(
        PersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder
      );

      function GetPersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder;

    public

      procedure RegisterPersonnelOrderControlGroupFinder(
        PersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder
      );

      function GetPersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder;

    public

      procedure RegisterPersonnelOrderSubKindFinder(
        PersonnelOrderSubKindFinder: IPersonnelOrderSubKindFinder
      );

      function GetPersonnelOrderSubKindFinder: IPersonnelOrderSubKindFinder;
      
    public

      class property Instance: TPersonnelOrderSearchServiceRegistry
      read GetInstance write SetInstance;

  end;
  
implementation

{ TPersonnelOrderSearchServiceRegistry }

constructor TPersonnelOrderSearchServiceRegistry.Create;
begin

  inherited;

  FSingleEmployeeListFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSubKindEmployeeListFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSubKindEmployeeGroupFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FSingleEmployeeListFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := False;
  FSubKindEmployeeListFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := False;
  FSubKindEmployeeGroupFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := False;

end;

destructor TPersonnelOrderSearchServiceRegistry.Destroy;
begin

  FreeAndNil(FSingleEmployeeListFinderRegistry);
  FreeAndNil(FSubKindEmployeeListFinderRegistry);
  FreeAndNil(FSubKindEmployeeGroupFinderRegistry);

  inherited;

end;

class function TPersonnelOrderSearchServiceRegistry.GetInstance: TPersonnelOrderSearchServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TPersonnelOrderSearchServiceRegistry.Create;

  Result := FInstance;

end;

function TPersonnelOrderSearchServiceRegistry.
  GetPersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder;
begin

  Result :=
    IPersonnelOrderApproverListFinder(
      FSubKindEmployeeListFinderRegistry.GetInterface(TPersonnelOrderApproverList)
    );
    
end;

function TPersonnelOrderSearchServiceRegistry.
  GetPersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder;
begin

  Result :=
    IPersonnelOrderControlGroupFinder(
      FSubKindEmployeeGroupFinderRegistry.GetInterface(TPersonnelOrderControlGroup)
    );

end;

function TPersonnelOrderSearchServiceRegistry.
  GetPersonnelOrderCreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder;
begin

  Result :=
    IPersonnelOrderCreatingAccessEmployeeListFinder(
      FSingleEmployeeListFinderRegistry.GetInterface(TPersonnelOrderCreatingAccessEmployeeList)
    );

end;

function TPersonnelOrderSearchServiceRegistry.
  GetPersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;
begin

  Result :=
    IPersonnelOrderSignerListFinder(
      FSingleEmployeeListFinderRegistry.GetInterface(TPersonnelOrderSignerList)
    );
    
end;

function TPersonnelOrderSearchServiceRegistry.GetPersonnelOrderSubKindFinder: IPersonnelOrderSubKindFinder;
begin

  Result := FPersonnelOrderSubKindFinder;
  
end;

procedure TPersonnelOrderSearchServiceRegistry.RegisterPersonnelOrderApproverListFinder(
  PersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder
);
begin

  FSubKindEmployeeListFinderRegistry.RegisterInterface(
    TPersonnelOrderApproverList, PersonnelOrderApproverListFinder
  );

end;

procedure TPersonnelOrderSearchServiceRegistry.RegisterPersonnelOrderControlGroupFinder(
  PersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder);
begin

  FSubKindEmployeeGroupFinderRegistry.RegisterInterface(
    TPersonnelOrderControlGroup,
    PersonnelOrderControlGroupFinder
  );

end;

procedure TPersonnelOrderSearchServiceRegistry.RegisterPersonnelOrderCreatingAccessEmployeeFinder(
  PersonnelOrderCreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder);
begin

  FSingleEmployeeListFinderRegistry.RegisterInterface(
    TPersonnelOrderCreatingAccessEmployeeList,
    PersonnelOrderCreatingAccessEmployeeFinder
  );
  
end;

procedure TPersonnelOrderSearchServiceRegistry.RegisterPersonnelOrderSignerListFinder(
  PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder);
begin

  FSingleEmployeeListFinderRegistry.RegisterInterface(
    TPersonnelOrderSignerList,
    PersonnelOrderSignerListFinder
  );

end;

procedure TPersonnelOrderSearchServiceRegistry.RegisterPersonnelOrderSubKindFinder(
  PersonnelOrderSubKindFinder: IPersonnelOrderSubKindFinder);
begin

  FPersonnelOrderSubKindFinder := PersonnelOrderSubKindFinder;
  
end;

class procedure TPersonnelOrderSearchServiceRegistry.SetInstance(
  const Value: TPersonnelOrderSearchServiceRegistry);
begin

  FInstance := Value;

end;

end.
