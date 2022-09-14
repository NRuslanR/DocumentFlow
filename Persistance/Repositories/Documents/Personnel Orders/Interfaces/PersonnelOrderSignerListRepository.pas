unit PersonnelOrderSignerListRepository;

interface

uses

  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderSignerList,
  PersonnelOrderEmployeeList,
  PersonnelOrderEmployeeListRepository,
  SysUtils;

type

  TPersonnelOrderSignerListEmployeeAssociation = class (TPersonnelOrderEmployeeListEmployeeAssociation)

    protected

      FIsDefaultSigner: Boolean;

    protected

      class function CreatePersonnelOrderEmployeeListEmployeeAssociationInstanceFrom(
        PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
        const EmployeeId: Variant
      ): TPersonnelOrderEmployeeListEmployeeAssociation; override;

    public

      constructor Create(
        EmployeeListId: Variant;
        EmployeeId: Variant;
        IsDefaultSigner: Boolean
      );

    published

      property IsDefaultSigner: Boolean
      read FIsDefaultSigner write FIsDefaultSigner;
      
  end;

  TPersonnelOrderSignerListEmployeeAssociations = class (TPersonnelOrderEmployeeListEmployeeAssociations)
  
  end;
  
  IPersonnelOrderSignerListRepository = interface (IPersonnelOrderSingleEmployeeListRepository)

    function GetPersonnelOrderSignerList: TPersonnelOrderSignerList;

    procedure UpdatePersonnelOrderSignerList(
      SignerList: TPersonnelOrderSignerList
    );
    
  end;
  
implementation

{ TPersonnelOrderSignerListEmployeeAssociation }

constructor TPersonnelOrderSignerListEmployeeAssociation.Create(EmployeeListId,
  EmployeeId: Variant; IsDefaultSigner: Boolean);
begin

  inherited Create(EmployeeListId, EmployeeId);

  FIsDefaultSigner := IsDefaultSigner;
  
end;

class function TPersonnelOrderSignerListEmployeeAssociation.
  CreatePersonnelOrderEmployeeListEmployeeAssociationInstanceFrom(
    PersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
    const EmployeeId: Variant
  ): TPersonnelOrderEmployeeListEmployeeAssociation;
begin

  Result :=
    TPersonnelOrderSignerListEmployeeAssociation.Create(
      PersonnelOrderEmployeeList.Identity,
      EmployeeId,
      EmployeeId = TPersonnelOrderSignerList(PersonnelOrderEmployeeList).DefaultSignerId
    );
    
end;

end.
