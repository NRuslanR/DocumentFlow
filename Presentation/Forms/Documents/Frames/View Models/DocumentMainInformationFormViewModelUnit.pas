unit DocumentMainInformationFormViewModelUnit;

interface

uses

  SysUtils,
  Classes,
  DateUtils,
  DocumentResponsibleViewModelUnit,
  DocumentSignerViewModelUnit;

type

  TOnViewModelPropertyChangedEventHandler =
    procedure (
      Sender: TObject;
      const PropertyName: String
    ) of object;
    
  TDocumentMainInformationFormViewModel = class

    private

    protected

      FOnPropertyChangedEventHandler: TOnViewModelPropertyChangedEventHandler;
        
    protected

      FDocumentResponsibleViewModel: TDocumentResponsibleViewModel;
      FDocumentSignerViewModel: TDocumentSignerViewModel;

      FDocumentId: Variant;
      FBaseDocumentId: Variant;
      FDocumentAuthorIdentity: Variant;
      FKindId: Variant;
      FDocumentDate: Variant;
      FCreationDate: TDateTime;
      FCurrentWorkCycleStageNumber: Integer;
      FKind: String;
      FNumberPrefixPattern: String;
      FNumberPrefix: String;
      FNumberMainValue: String;
      FNumberPartsSeparator: String;
      FName: String;
      FContent: String;
      FNote: String;
      FIsSelfRegistered: Variant;
      FProductCode: Variant;
      FDocumentAuthorShortFullName: String;
      FCurrentWorkCycleStageName: String;
      FActualSignerName: String;
      FSigningDate: Variant;

    protected

      function CompileNumber(const Prefix, Separator, MainValue: String): String; { refactor }
      
    protected

      function GetProductCode: Variant; virtual;
      procedure SetProductCode(const Value: Variant); virtual;

      function GetContent: String; virtual;
      function GetCreationDate: TDateTime; virtual;
      function GetDocumentDate: Variant; virtual;
      function GetCurrentWorkCycleStageName: string; virtual;
      function GetCurrentWorkCycleStageNumber: Integer; virtual;
      function GetNumberPrefix: String; virtual;
      function GetNumberPartsSeparator: String; virtual;
      function GetDocumentAuthorIdentity: Variant; virtual;
      function GetDocumentAuthorShortFullName: String; virtual;
      function GetDocumentId: Variant; virtual;
      function GetBaseDocumentId: Variant; virtual;
      function GetDocumentResponsibleViewModel: TDocumentResponsibleViewModel; virtual;
      function GetDocumentSignerViewModel: TDocumentSignerViewModel; virtual;
      function GetKind: String; virtual;
      function GetKindId: Variant; virtual;
      function GetActualSignerName: String; virtual;
      function GetName: String; virtual;
      function GetNote: String; virtual;
      function GetIsSelfRegistered: Variant; virtual;
      function GetNumberMainValue: String; virtual;
      function GetSigningDate: Variant; virtual;
      function GetNumber: String; virtual;
      
      procedure SetContent(const Value: String); virtual;
      procedure SetCreationDate(const Value: TDateTime); virtual;
      procedure SetDocumentDate(const Value: Variant); virtual;
      procedure SetNumberPrefix(const Value: String); virtual;
      procedure SetNumberPartsSeparator(const Value: String); virtual;
      procedure SetDocumentAuthorIdentity(const Value: Variant); virtual;
      procedure SetDocumentAuthorShortFullName(const Value: String); virtual;
      procedure SetKindId(const Value: Variant); virtual;
      procedure SetName(const Value: String); virtual;
      procedure SetNote(const Value: String); virtual;
      procedure SetNumberMainValue(const Value: String); virtual;
      procedure SetDocumentId(const Value: Variant); virtual;
      procedure SetBaseDocumentId(const Value: Variant); virtual;
      procedure SetKind(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageName(const Value: string); virtual;
      procedure SetCurrentWorkCycleStageNumber(const Value: Integer); virtual;
      procedure SetActualSignerName(const Value: String); virtual;
      procedure SetSigningDate(const Value: Variant); virtual;
      procedure SetIsSelfRegistered(const Value: Variant); virtual;
      
      procedure SetDocumentResponsibleViewModel(
        DocumentResponsibleViewModel: TDocumentResponsibleViewModel
      ); virtual;

      procedure SetDocumentSignerViewModel(
        DocumentSignerViewModel: TDocumentSignerViewModel
      ); virtual;

      procedure SetNumber(const Value: String); virtual;

    protected

      procedure GetNumberPrefixAndMainValue(
        const Number, NumberPartsSeparator: String;
        var Prefix, MainValue: String
      );
      
    public

      constructor Create; virtual;
      destructor Destroy; override;

      procedure Clear;

    public
    
      function CreateClonedViewModelInstance:
        TDocumentMainInformationFormViewModel; virtual;

      procedure CopyFrom(Other: TDocumentMainInformationFormViewModel); virtual;

      function Clone: TDocumentMainInformationFormViewModel; virtual;

    published
    
      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;

      property BaseDocumentId: Variant
      read GetBaseDocumentId write SetBaseDocumentId;
      
      property DocumentAuthorIdentity: Variant
      read GetDocumentAuthorIdentity write SetDocumentAuthorIdentity;

      property DocumentAuthorShortFullName: String
      read GetDocumentAuthorShortFullName
      write SetDocumentAuthorShortFullName;

      property Kind: String read GetKind write SetKind;

      property ProductCode: Variant
      read GetProductCode write SetProductCode;
      
      property KindId: Variant read GetKindId write SetKindId;

      property NumberPrefixPattern: String
      read FNumberPrefixPattern write FNumberPrefixPattern;

      property NumberPrefix: String read GetNumberPrefix write SetNumberPrefix;

      property NumberMainValue: String read GetNumberMainValue write SetNumberMainValue;

      property NumberPartsSeparator: String
      read GetNumberPartsSeparator write SetNumberPartsSeparator;
      
      property CreationDate: TDateTime
      read GetCreationDate write SetCreationDate;

      property DocumentDate: Variant
      read GetDocumentDate write SetDocumentDate;
      
      property Name: String read GetName write SetName;

      property Content: String read GetContent write SetContent;

      property Number: String read GetNumber write SetNumber;

      property Note: String read GetNote write SetNote;

      property IsSelfRegistered: Variant
      read GetIsSelfRegistered write SetIsSelfRegistered;

      property DocumentResponsibleViewModel: TDocumentResponsibleViewModel
      read GetDocumentResponsibleViewModel write SetDocumentResponsibleViewModel;

      property DocumentSignerViewModel: TDocumentSignerViewModel
      read GetDocumentSignerViewModel write SetDocumentSignerViewModel;

      property ActualSignerName: String
      read GetActualSignerName write SetActualSignerName;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber write SetCurrentWorkCycleStageNumber;
      
      property CurrentWorkCycleStageName: string
      read GetCurrentWorkCycleStageName write SetCurrentWorkCycleStageName;

      property SigningDate: Variant
      read GetSigningDate write SetSigningDate;

    published

      property OnPropertyChangedEventHandler:
        TOnViewModelPropertyChangedEventHandler
      read FOnPropertyChangedEventHandler
      write FOnPropertyChangedEventHandler;

  end;

  TDocumentMainInformationFormViewModelClass =
    class of TDocumentMainInformationFormViewModel;

implementation

uses

  AuxiliaryStringFunctions,
  StrUtils,
  Variants;
  
procedure TDocumentMainInformationFormViewModel.Clear;
begin

  FName := '';
  FNumberPrefix := '';
  FNumberPrefixPattern := '';
  FNumberPartsSeparator := '';
  FNumberMainValue := '';
  FContent := '';
  FNote := '';

  FDocumentResponsibleViewModel.Clear;
  FDocumentSignerViewModel.Clear;

end;

function TDocumentMainInformationFormViewModel.Clone: TDocumentMainInformationFormViewModel;
begin

  Result := CreateClonedViewModelInstance;

  Result.CopyFrom(Self);
  
end;

function TDocumentMainInformationFormViewModel.CompileNumber(
  const Prefix, Separator, MainValue: String
): String;
begin

  Result :=
    IfThen(
      (Trim(Prefix) <> '') and (Trim(MainValue) <> ''),
      Prefix + Separator + MainValue,
      MainValue
    );
    
end;

procedure TDocumentMainInformationFormViewModel.CopyFrom(
  Other: TDocumentMainInformationFormViewModel
);
begin

  DocumentResponsibleViewModel.CopyFrom(Other.DocumentResponsibleViewModel);
  DocumentSignerViewModel.CopyFrom(Other.DocumentSignerViewModel);

  DocumentId := Other.DocumentId;
  DocumentAuthorIdentity := Other.DocumentAuthorIdentity;
  Kind := Other.Kind;
  KindId := Other.KindId;
  NumberPartsSeparator := Other.NumberPartsSeparator;
  Number := Other.Number;
  NumberPrefixPattern := Other.NumberPrefixPattern;
  NumberPrefix := Other.NumberPrefix;
  NumberMainValue := Other.NumberMainValue;
  DocumentDate := Other.DocumentDate;
  CreationDate := Other.CreationDate;
  Name := Other.Name;
  Content := Other.Content;
  Note := Other.Note;
  IsSelfRegistered := Other.IsSelfRegistered;
  CurrentWorkCycleStageName := Other.CurrentWorkCycleStageName;
  ProductCode := Other.ProductCode;
  ActualSignerName := Other.ActualSignerName;
  SigningDate := Other.SigningDate;

end;

constructor TDocumentMainInformationFormViewModel.Create;
begin

  inherited Create;

  FDocumentId := Null;
  FKindId := Null;
  FDocumentAuthorIdentity := Null;
  FSigningDate := Null;
  FDocumentDate := Null;
  FNumberPartsSeparator := '/'; { refactor: get number info from dto }
  
  FDocumentResponsibleViewModel := TDocumentResponsibleViewModel.Create;
  FDocumentSignerViewModel := TDocumentSignerViewModel.Create;

end;

function TDocumentMainInformationFormViewModel.CreateClonedViewModelInstance: TDocumentMainInformationFormViewModel;
begin

  Result := TDocumentMainInformationFormViewModelClass(ClassType).Create;
  
end;

destructor TDocumentMainInformationFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentResponsibleViewModel);
  FreeAndNil(FDocumentSignerViewModel);

  inherited;

end;

function TDocumentMainInformationFormViewModel.GetBaseDocumentId: Variant;
begin

  Result := FBaseDocumentId;
  
end;

function TDocumentMainInformationFormViewModel.GetContent: String;
begin

  Result := FContent;

end;

function TDocumentMainInformationFormViewModel.GetCreationDate: TDateTime;
begin

  Result := FCreationDate;
  
end;

function TDocumentMainInformationFormViewModel.GetCurrentWorkCycleStageName: string;
begin

  Result := FCurrentWorkCycleStageName;

end;

function TDocumentMainInformationFormViewModel.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FCurrentWorkCycleStageNumber;
  
end;

function TDocumentMainInformationFormViewModel.GetNumberPartsSeparator: String;
begin

  Result := FNumberPartsSeparator;
  
end;

function TDocumentMainInformationFormViewModel.GetNumberPrefix: String;
begin

  Result := FNumberPrefix;

end;

procedure TDocumentMainInformationFormViewModel.GetNumberPrefixAndMainValue(
  const Number, NumberPartsSeparator: String; var Prefix, MainValue: String);
var
    I: Integer;
begin

  I := Pos(NumberPartsSeparator, Number);

  if I = 0 then begin

    Prefix := '';
    MainValue := Number;

  end

  else begin

    Prefix := Copy(Number, 1, I - 1);
    MainValue := Copy(Number, I + 1, Length(Number) - I);
    
  end;

end;

function TDocumentMainInformationFormViewModel.GetProductCode: Variant;
begin

  Result := FProductCode;

end;

function TDocumentMainInformationFormViewModel.GetDocumentAuthorIdentity: Variant;
begin

  Result := FDocumentAuthorIdentity;
  
end;

function TDocumentMainInformationFormViewModel.GetDocumentAuthorShortFullName: String;
begin

  Result := FDocumentAuthorShortFullName;
  
end;

function TDocumentMainInformationFormViewModel.GetNumber: String;
begin

  Result := CompileNumber(NumberPrefix, NumberPartsSeparator, NumberMainValue);
  
end;

function TDocumentMainInformationFormViewModel.GetDocumentDate: Variant;
begin

  Result := FDocumentDate;
  
end;

function TDocumentMainInformationFormViewModel.GetDocumentId: Variant;
begin

  Result := FDocumentId;
  
end;

function TDocumentMainInformationFormViewModel.GetDocumentResponsibleViewModel: TDocumentResponsibleViewModel;
begin

  Result := FDocumentResponsibleViewModel;
  
end;

function TDocumentMainInformationFormViewModel.GetDocumentSignerViewModel: TDocumentSignerViewModel;
begin

  Result := FDocumentSignerViewModel;
  
end;

function TDocumentMainInformationFormViewModel.GetIsSelfRegistered: Variant;
begin

  Result := FIsSelfRegistered;
  
end;

function TDocumentMainInformationFormViewModel.GetKind: String;
begin

  Result := FKind;
  
end;

function TDocumentMainInformationFormViewModel.GetKindId: Variant;
begin

  Result := FKindId;
  
end;

function TDocumentMainInformationFormViewModel.GetActualSignerName: String;
begin

  Result := FActualSignerName;
  
end;

function TDocumentMainInformationFormViewModel.GetName: String;
begin

  Result := FName;
  
end;

function TDocumentMainInformationFormViewModel.GetNote: String;
begin

  Result := FNote;
  
end;

function TDocumentMainInformationFormViewModel.GetNumberMainValue: String;
begin

  Result := FNumberMainValue;

end;

function TDocumentMainInformationFormViewModel.GetSigningDate: Variant;
begin

  Result := FSigningDate;
  
end;

procedure TDocumentMainInformationFormViewModel.SetDocumentSignerViewModel(
  DocumentSignerViewModel: TDocumentSignerViewModel);
begin

  FreeAndNil(FDocumentSignerViewModel);

  FDocumentSignerViewModel := DocumentSignerViewModel;

end;

procedure TDocumentMainInformationFormViewModel.SetIsSelfRegistered(
  const Value: Variant);
begin

  FIsSelfRegistered := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetBaseDocumentId(
  const Value: Variant);
begin

  FBaseDocumentId := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetContent(const Value: String);
begin

  FContent := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetCreationDate(
  const Value: TDateTime);
begin

  FCreationDate := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetCurrentWorkCycleStageName(
  const Value: string);
begin

  FCurrentWorkCycleStageName := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetCurrentWorkCycleStageNumber(
  const Value: Integer);
begin

  FCurrentWorkCycleStageNumber := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetNumberPartsSeparator(
  const Value: String);
begin

  FNumberPartsSeparator := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetNumberPrefix(
  const Value: String);
begin

  FNumberPrefix := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetProductCode(
  const Value: Variant);
begin

  FProductCode := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetDocumentAuthorIdentity(
  const Value: Variant);
begin

  FDocumentAuthorIdentity := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetDocumentAuthorShortFullName(
  const Value: String);
begin

  FDocumentAuthorShortFullName := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetKind(const Value: String);
begin

  FKind := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetKindId(
  const Value: Variant);
begin

  FKindId := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetActualSignerName(
  const Value: String);
begin

  FActualSignerName := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetName(const Value: String);
begin

  FName := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetNote(const Value: String);
begin

  FNote := Value;

end;

procedure TDocumentMainInformationFormViewModel.SetNumberMainValue(const Value: String);
begin

  FNumberMainValue := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetSigningDate(
  const Value: Variant);
begin

  FSigningDate := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetNumber(
  const Value: String);
var I: Integer;
begin
                
  GetNumberPrefixAndMainValue(Value, NumberPartsSeparator, FNumberPrefix, FNumberMainValue);

  if Assigned(FOnPropertyChangedEventHandler) then begin
  
    FOnPropertyChangedEventHandler(
      Self, 'Number'
    );

  end;

end;

procedure TDocumentMainInformationFormViewModel.SetDocumentDate(
  const Value: Variant);
begin

  FDocumentDate := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetDocumentId(
  const Value: Variant);
begin

  FDocumentId := Value;
  
end;

procedure TDocumentMainInformationFormViewModel.SetDocumentResponsibleViewModel(
  DocumentResponsibleViewModel: TDocumentResponsibleViewModel);
begin

  FreeAndNil(FDocumentResponsibleViewModel);

  FDocumentResponsibleViewModel := DocumentResponsibleViewModel;

end;


end.
