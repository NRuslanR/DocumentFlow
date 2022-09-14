unit SelectionDepartmentsReferenceFormViewModel;

interface

uses

  SelectionDepartmentSetHolder,
  SysUtils,
  Classes;

type

  TSelectionDepartmentsReferenceFormViewModel = class

    private

      FSelectionDepartmentSetHolder: TSelectionDepartmentSetHolder;

      function GetSelectionDepartmentSetHolder: TSelectionDepartmentSetHolder;

      procedure SetSelectionDepartmentSetHolder(
        const Value: TSelectionDepartmentSetHolder
      );

    public

      destructor Destroy; override;
      
      constructor Create(SelectionDepartmentSetHolder: TSelectionDepartmentSetHolder);

      property SelectionDepartmentSetHolder: TSelectionDepartmentSetHolder
      read GetSelectionDepartmentSetHolder
      write SetSelectionDepartmentSetHolder;

  end;


implementation

{ TSelectionDepartmentsReferenceFormViewModel }

constructor TSelectionDepartmentsReferenceFormViewModel.Create(
  SelectionDepartmentSetHolder: TSelectionDepartmentSetHolder);
begin

  inherited Create;

  FSelectionDepartmentSetHolder := SelectionDepartmentSetHolder;
  
end;

destructor TSelectionDepartmentsReferenceFormViewModel.Destroy;
begin

  FreeAndNil(FSelectionDepartmentSetHolder);
  
  inherited;

end;

function TSelectionDepartmentsReferenceFormViewModel.GetSelectionDepartmentSetHolder: TSelectionDepartmentSetHolder;
begin

  Result := FSelectionDepartmentSetHolder;

end;

procedure TSelectionDepartmentsReferenceFormViewModel.SetSelectionDepartmentSetHolder(
  const Value: TSelectionDepartmentSetHolder);
begin

  if FSelectionDepartmentSetHolder = Value then Exit;

  FreeAndNil(FSelectionDepartmentSetHolder);

  FSelectionDepartmentSetHolder := Value;
  
end;

end.
