unit SelectionDepartmentsReferenceFormViewModelMapper;

interface

uses

  SelectionDepartmentsReferenceFormViewModel,
  SelectionDepartmentSetHolder,
  DepartmentSetHolder,
  SysUtils;

type

  TSelectionDepartmentsReferenceFormViewModelMapper = class

    private

      function CreateSelectionDepartmentSetHolderFrom(
        DepartmentSetHolder: TDepartmentSetHolder
      ): TSelectionDepartmentSetHolder;
      
    public

      function MapSelectionDepartmentsReferenceFormViewModelFrom(
        DepartmentSetHolder: TDepartmentSetHolder
      ): TSelectionDepartmentsReferenceFormViewModel;
      
  end;


implementation

uses

  DB,
  AuxDataSetFunctionsUnit;
  
{ TSelectionDepartmentsReferenceFormViewModelMapper }

function TSelectionDepartmentsReferenceFormViewModelMapper.
  MapSelectionDepartmentsReferenceFormViewModelFrom(
    DepartmentSetHolder: TDepartmentSetHolder
  ): TSelectionDepartmentsReferenceFormViewModel;
var
    SelectionDepartmentSetHolder: TSelectionDepartmentSetHolder;
begin

  SelectionDepartmentSetHolder :=
    CreateSelectionDepartmentSetHolderFrom(DepartmentSetHolder);

  try

    Result :=
      TSelectionDepartmentsReferenceFormViewModel.Create(SelectionDepartmentSetHolder);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TSelectionDepartmentsReferenceFormViewModelMapper.
  CreateSelectionDepartmentSetHolderFrom(
    DepartmentSetHolder: TDepartmentSetHolder
  ): TSelectionDepartmentSetHolder;
var
    Field: TField;
begin

  Result := TSelectionDepartmentSetHolder.Create;

  try

    Result.DataSet := DepartmentSetHolder.ExtractDataSet;

    Result.FieldDefs := TSelectionDepartmentSetFieldDefs.Create;

    with Result.FieldDefs do begin

      IsSelectedFieldName := DepartmentSetHolder.IsSelectedFieldName;
      DepartmentIdFieldName := DepartmentSetHolder.DepartmentIdFieldName;
      CodeFieldName := DepartmentSetHolder.CodeFieldName;
      ShortNameFieldName := DepartmentSetHolder.ShortNameFieldName;
      FullNameFieldName := DepartmentSetHolder.FullNameFieldName;
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
