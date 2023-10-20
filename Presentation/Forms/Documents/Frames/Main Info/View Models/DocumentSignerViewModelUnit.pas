unit DocumentSignerViewModelUnit;

interface

type

  TDocumentSignerViewModel = class

    protected

      FId: Variant;
      FName: String;
      FSpeciality: String;
      FDepartmentCode: String;
      FDepartmentShortName: String;

    public

      constructor Create;

      procedure Clear;

      procedure CopyFrom(Other: TDocumentSignerViewModel); virtual;

    published
    
      property Id: Variant read FId write FId;
      property Name: String read FName write FName;
      property Speciality: String read FSpeciality write FSpeciality;
      property DepartmentShortName: String read FDepartmentShortName write FDepartmentShortName;
      property DepartmentCode: String
      read FDepartmentCode write FDepartmentCode;

  end;
  
implementation

uses

  Variants;
  
{ TDocumentSignerViewModel }

procedure TDocumentSignerViewModel.Clear;
begin

  FName := '';
  FDepartmentShortName := '';
  
end;

procedure TDocumentSignerViewModel.CopyFrom(Other: TDocumentSignerViewModel);
begin

  Id := Other.Id;
  Name := Other.Name;
  DepartmentShortName := Other.DepartmentShortName;
  
end;

constructor TDocumentSignerViewModel.Create;
begin

  inherited;

  FId := Null;
  
end;

end.
