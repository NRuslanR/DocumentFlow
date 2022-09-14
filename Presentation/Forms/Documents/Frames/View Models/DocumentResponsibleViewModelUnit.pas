unit DocumentResponsibleViewModelUnit;

interface

type

  TDocumentResponsibleViewModel = class

    protected

      FId: Variant;
      FName: String;
      FTelephoneNumber: String;
      FDepartmentCode: String;
      FDepartmentShortName: String;

    public

      constructor Create;

      procedure Clear;

      procedure CopyFrom(Other: TDocumentResponsibleViewModel); virtual;

    published
    
      property Id: Variant read FId write FId;
      property Name: String read FName write FName;
      property TelephoneNumber: String read FTelephoneNumber write FTelephoneNumber;
      property DepartmentCode: String read FDepartmentCode write FDepartmentCode;
      property DepartmentShortName: String read FDepartmentShortName write FDepartmentShortName;

  end;

implementation

uses

  Variants;

{ TDocumentResponsibleViewModel }

procedure TDocumentResponsibleViewModel.Clear;
begin

  FName := '';
  FTelephoneNumber := '';
  FDepartmentCode := '';
  FDepartmentShortName := '';
  
end;

procedure TDocumentResponsibleViewModel.CopyFrom(
  Other: TDocumentResponsibleViewModel);
begin

  Id := Other.Id;
  Name := Other.Name;
  TelephoneNumber := Other.TelephoneNumber;
  DepartmentCode := Other.DepartmentCode;
  DepartmentShortName := Other.DepartmentShortName;
  
end;

constructor TDocumentResponsibleViewModel.Create;
begin

  inherited;

  FId := Null;
  
end;

end.
