unit PersonnelOrderEmployeeListRepository;

interface

uses

  PersonnelOrderEmployeeList,
  DomainObjectUnit,
  DomainObjectListUnit,
  SysUtils;

type

  TPersonnelOrderEmployeeListEmployeeAssociations = class;
  TPersonnelOrderEmployeeListEmployeeAssociationsClass = class of TPersonnelOrderEmployeeListEmployeeAssociations;
  
  TPersonnelOrderEmployeeListEmployeeAssociation = class (TDomainObject)

    strict protected

      FEmployeeId: Variant;

      function GetEmployeeId: Variant;
      function GetEmployeeListId: Variant;

      procedure SetEmployeeId(const Value: Variant);
      procedure SetEmployeeListId(const Value: Variant);

      class function CreatePersonnelOrderEmployeeListEmployeeAssociationInstanceFrom(
        PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
        const EmployeeId: Variant
      ): TPersonnelOrderEmployeeListEmployeeAssociation; virtual;

    public

      constructor Create(
        EmployeeListId: Variant;
        EmployeeId: Variant
      );

      class function CreateAssociationsFrom(
        PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList
      ): TPersonnelOrderEmployeeListEmployeeAssociations; overload;

      class function CreateAssociationsFrom(
        PersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists
      ): TPersonnelOrderEmployeeListEmployeeAssociations; overload;
      
    public

      property EmployeeListId: Variant read GetEmployeeListId write SetEmployeeListId;

    published
    
      property EmployeeId: Variant read GetEmployeeId write SetEmployeeId;

  end;

  TPersonnelOrderEmployeeListEmployeeAssociations = class (TDomainObjectList)

  end;
  
  IPersonnelOrderEmployeeListRepository = interface

    function FindPersonnelOrderEmployeeList(const Id: Variant): TPersonnelOrderEmployeeList;

    function FindAllPersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists;

    procedure AddPersonnelOrderEmployeeList(
      EmployeeList: TPersonnelOrderEmployeeList
    );

    procedure AddPersonnelOrderEmployeeLists(
      EmployeeLists: TPersonnelOrderEmployeeLists
    );

    procedure UpdatePersonnelOrderEmployeeList(
      EmployeeList: TPersonnelOrderEmployeeList
    );

    procedure UpdatePersonnelOrderEmployeeLists(
      EmployeeLists: TPersonnelOrderEmployeeLists
    );

    procedure RemovePersonnelOrderEmployeeList(
      EmployeeList: TPersonnelOrderEmployeeList
    );

    procedure RemovePersonnelOrderEmployeeLists(
      EmployeeLists: TPersonnelOrderEmployeeLists
    );

  end;

implementation

uses

  IDomainObjectBaseListUnit;

{ TPersonnelOrderEmployeeListEmployeeAssociation }

constructor TPersonnelOrderEmployeeListEmployeeAssociation.Create(
  EmployeeListId, EmployeeId: Variant);
begin

  inherited Create;

  Self.EmployeeListId := EmployeeListId;
  Self.EmployeeId := EmployeeId;
  
end;

class function TPersonnelOrderEmployeeListEmployeeAssociation.
  CreateAssociationsFrom(
    PersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists
  ): TPersonnelOrderEmployeeListEmployeeAssociations;
var
    PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
    Associations: TPersonnelOrderEmployeeListEmployeeAssociations;
    Free: IDomainObjectBaseList;
begin

  Result := TPersonnelOrderEmployeeListEmployeeAssociations.Create;

  try

    for PersonnelOrderEmployeeList in PersonnelOrderEmployeeLists do begin

      Associations := CreateAssociationsFrom(PersonnelOrderEmployeeList);

      Free := Associations;

      Result.AddDomainObjectList(Associations);
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

class function TPersonnelOrderEmployeeListEmployeeAssociation.
  CreatePersonnelOrderEmployeeListEmployeeAssociationInstanceFrom(
    PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
    const EmployeeId: Variant
  ): TPersonnelOrderEmployeeListEmployeeAssociation;
begin

  Result :=
    TPersonnelOrderEmployeeListEmployeeAssociation.Create(
      PersonnelOrderEmployeeList.Identity, EmployeeId
    );

end;

class function TPersonnelOrderEmployeeListEmployeeAssociation.
  CreateAssociationsFrom(
    PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList
  ): TPersonnelOrderEmployeeListEmployeeAssociations;
var
    EmployeeId: Variant;
begin

  Result := TPersonnelOrderEmployeeListEmployeeAssociations.Create;

  try

    for EmployeeId in PersonnelOrderEmployeeList.EmployeeIds do begin

      Result.AddDomainObject(
        CreatePersonnelOrderEmployeeListEmployeeAssociationInstanceFrom(
          PersonnelOrderEmployeeList, EmployeeId
        )
      );

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TPersonnelOrderEmployeeListEmployeeAssociation.GetEmployeeId: Variant;
begin

  Result := FEmployeeId;
  
end;

function TPersonnelOrderEmployeeListEmployeeAssociation.GetEmployeeListId: Variant;
begin

  Result := Identity;;
  
end;

procedure TPersonnelOrderEmployeeListEmployeeAssociation.SetEmployeeId(
  const Value: Variant);
begin

  FEmployeeId := Value;
  
end;

procedure TPersonnelOrderEmployeeListEmployeeAssociation.SetEmployeeListId(
  const Value: Variant);
begin

  Identity := Value;
  
end;

end.
