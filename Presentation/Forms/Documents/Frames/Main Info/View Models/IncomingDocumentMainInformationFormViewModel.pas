unit IncomingDocumentMainInformationFormViewModel;

interface

uses

  DocumentMainInformationFormViewModelUnit,
  DocumentResponsibleViewModelUnit,
  DocumentSignerViewModelUnit,
  SysUtils,
  Classes;

type

  TIncomingDocumentMainInformationFormViewModel =
    class (TDocumentMainInformationFormViewModel)

      protected

        FDocumentMainInformationFormViewModel:
          TDocumentMainInformationFormViewModel;
          
        FIncomingNumberPrefix: String;
        FIncomingNumberMainValue: String;
        FIncomingNumberPartsSeparator: String;
        FReceiptDate: TDateTime;
        
      protected

        function GetProductCode: Variant; override;
        procedure SetProductCode(const Value: Variant); override;

        function GetContent: String; override;
        function GetCreationDate: TDateTime; override;
        function GetDocumentDate: Variant; override;
        function GetCurrentWorkCycleStageName: string; override;
        function GetCurrentWorkCycleStageNumber: Integer; override;
        function GetNumberPrefix: String; override;
        function GetDocumentAuthorIdentity: Variant; override;
        function GetDocumentAuthorShortFullName: String; override;
        function GetDocumentId: Variant; override;
        function GetDocumentResponsibleViewModel: TDocumentResponsibleViewModel; override;
        function GetDocumentSignerViewModel: TDocumentSignerViewModel; override;
        function GetKind: String; override;
        function GetKindId: Variant; override;
        function GetActualSignerName: String; override;
        function GetName: String; override;
        function GetNote: String; override;
        function GetIsSelfRegistered: Variant; override;
        function GetNumberMainValue: String; override;
        function GetSigningDate: Variant; override;
        function GetNumber: String; override;

        procedure SetContent(const Value: String); override;
        procedure SetCreationDate(const Value: TDateTime); override;
        procedure SetDocumentDate(const Value: Variant); override;
        procedure SetNumberPrefix(const Value: String); override;
        procedure SetDocumentAuthorIdentity(const Value: Variant); override;
        procedure SetDocumentAuthorShortFullName(const Value: String); override;
        procedure SetKindId(const Value: Variant); override;
        procedure SetName(const Value: String); override;
        procedure SetNote(const Value: String); override;
        procedure SetIsSelfRegistered(const Value: Variant); override;
        procedure SetNumberMainValue(const Value: String); override;
        procedure SetDocumentId(const Value: Variant); override;
        procedure SetKind(const Value: String); override;
        procedure SetCurrentWorkCycleStageName(const Value: string); override;
        procedure SetCurrentWorkCycleStageNumber(const Value: Integer); override;
        procedure SetActualSignerName(const Value: String); override;
        procedure SetSigningDate(const Value: Variant); override;

        procedure SetDocumentResponsibleViewModel(
          DocumentResponsibleViewModel: TDocumentResponsibleViewModel
        ); override;

        procedure SetDocumentSignerViewModel(
          DocumentSignerViewModel: TDocumentSignerViewModel
        ); override;

        procedure SetNumber(const Value: String); override;

        procedure SetDocumentMainInformationFormViewModel(
          Value: TDocumentMainInformationFormViewModel
        );

        function GetIncomingNumber: String;
        procedure SetIncomingNumber(const Value: String);
        
      public

        destructor Destroy; override;
        constructor Create(
          DocumentMainInformationFormViewModel:
            TDocumentMainInformationFormViewModel
        );

      public

        function CreateClonedViewModelInstance:
        TDocumentMainInformationFormViewModel; override;

        procedure CopyFrom(
          Other: TDocumentMainInformationFormViewModel
        ); override;

        function Clone: TDocumentMainInformationFormViewModel; override;

      published

        property IncomingNumberPrefix: String
        read FIncomingNumberPrefix
        write FIncomingNumberPrefix;

        property IncomingNumberMainValue: String
        read FIncomingNumberMainValue
        write FIncomingNumberMainValue;

        property IncomingNumberPartsSeparator: String
        read FIncomingNumberPartsSeparator write FIncomingNumberPartsSeparator;
        
        property IncomingNumber: String
        read GetIncomingNumber write SetIncomingNumber;
        
        property ReceiptDate: TDateTime
        read FReceiptDate write FReceiptDate;

        property OriginalDocumentMainInformationFormViewModel:
          TDocumentMainInformationFormViewModel
        read FDocumentMainInformationFormViewModel
        write SetDocumentMainInformationFormViewModel;
        
    end;
    
implementation

uses

  AuxDebugFunctionsUnit;

{ TIncomingDocumentMainInformationFormViewModel }

function TIncomingDocumentMainInformationFormViewModel.Clone: TDocumentMainInformationFormViewModel;
var
    ClonedIncomingDocumentMainInformationFormViewModel: TIncomingDocumentMainInformationFormViewModel;
begin

  Result := inherited Clone;

  ClonedIncomingDocumentMainInformationFormViewModel :=
    TIncomingDocumentMainInformationFormViewModel(Result);

end;

procedure TIncomingDocumentMainInformationFormViewModel.CopyFrom(
  Other: TDocumentMainInformationFormViewModel);
var OtherViewModel: TIncomingDocumentMainInformationFormViewModel;
begin

  OtherViewModel := Other as TIncomingDocumentMainInformationFormViewModel;

  OriginalDocumentMainInformationFormViewModel.CopyFrom(
    OtherViewModel.OriginalDocumentMainInformationFormViewModel
  );

  IncomingNumberPartsSeparator := OtherViewModel.IncomingNumberPartsSeparator;
  IncomingNumber := OtherViewModel.IncomingNumber;
  IncomingNumberPrefix := OtherViewModel.IncomingNumberPrefix;
  IncomingNumberMainValue := OtherViewModel.IncomingNumberMainValue;
  FReceiptDate := OtherViewModel.ReceiptDate;
  FKindId := OtherViewModel.KindId;
  FKind := OtherViewModel.Kind;
  FDocumentId := OtherViewModel.DocumentId;
  
end;

constructor TIncomingDocumentMainInformationFormViewModel.Create(
  DocumentMainInformationFormViewModel: TDocumentMainInformationFormViewModel);
begin

  inherited Create;

  FDocumentMainInformationFormViewModel :=
    DocumentMainInformationFormViewModel;

  IncomingNumberPartsSeparator := '/'; { refactor: get from dto }
    
end;

function TIncomingDocumentMainInformationFormViewModel.CreateClonedViewModelInstance: TDocumentMainInformationFormViewModel;
var ClonedViewModel: TIncomingDocumentMainInformationFormViewModel;
begin

  Result := inherited CreateClonedViewModelInstance;

  ClonedViewModel := Result as TIncomingDocumentMainInformationFormViewModel;

  ClonedViewModel.OriginalDocumentMainInformationFormViewModel :=
    OriginalDocumentMainInformationFormViewModel.
      CreateClonedViewModelInstance;
      
end;

destructor TIncomingDocumentMainInformationFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentMainInformationFormViewModel);
  inherited;

end;

function TIncomingDocumentMainInformationFormViewModel.GetContent: String;
begin

  Result := FDocumentMainInformationFormViewModel.Content;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetCreationDate: TDateTime;
begin

  Result := FDocumentMainInformationFormViewModel.CreationDate;

end;

function TIncomingDocumentMainInformationFormViewModel.GetCurrentWorkCycleStageName: string;
begin

  Result := FDocumentMainInformationFormViewModel.CurrentWorkCycleStageName;

end;

function TIncomingDocumentMainInformationFormViewModel.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FDocumentMainInformationFormViewModel.CurrentWorkCycleStageNumber;

end;

function TIncomingDocumentMainInformationFormViewModel.GetNumberPrefix: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.NumberPrefix;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetProductCode: Variant;
begin

  Result := FDocumentMainInformationFormViewModel.ProductCode;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentAuthorIdentity: Variant;
begin

  Result := FDocumentMainInformationFormViewModel.DocumentAuthorIdentity;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentAuthorShortFullName: String;
begin

  Result := FDocumentMainInformationFormViewModel.DocumentAuthorShortFullName;

end;

function TIncomingDocumentMainInformationFormViewModel.GetNumber: String;
begin

  Result := FDocumentMainInformationFormViewModel.Number;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentDate: Variant;
begin

  Result := FDocumentMainInformationFormViewModel.DocumentDate;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentId: Variant;
begin

  Result := inherited GetDocumentId;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentResponsibleViewModel: TDocumentResponsibleViewModel;
begin

  Result := FDocumentMainInformationFormViewModel.DocumentResponsibleViewModel;

end;

function TIncomingDocumentMainInformationFormViewModel.GetDocumentSignerViewModel: TDocumentSignerViewModel;
begin

  Result := FDocumentMainInformationFormViewModel.DocumentSignerViewModel;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetIncomingNumber: String;
begin

  Result := CompileNumber(IncomingNumberPrefix, IncomingNumberPartsSeparator, IncomingNumberMainValue);
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetIsSelfRegistered: Variant;
begin

  Result :=
    FDocumentMainInformationFormViewModel.IsSelfRegistered;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetKind: String;
begin

  Result := inherited GetKind;
  
end;

function TIncomingDocumentMainInformationFormViewModel.GetKindId: Variant;
begin

  Result := inherited GetKindId;

end;

function TIncomingDocumentMainInformationFormViewModel.GetActualSignerName: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.ActualSignerName;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetName: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.Name;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetNote: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.Note;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetNumberMainValue: String;
begin

  Result :=
    FDocumentMainInformationFormViewModel.NumberMainValue;
    
end;

function TIncomingDocumentMainInformationFormViewModel.GetSigningDate: Variant;
begin

  Result :=
    FDocumentMainInformationFormViewModel.SigningDate;
    
end;

procedure TIncomingDocumentMainInformationFormViewModel.SetContent(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.Content := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetCreationDate(
  const Value: TDateTime);
begin

  FDocumentMainInformationFormViewModel.CreationDate := Value;
  
end;

procedure TIncomingDocumentMainInformationFormViewModel.SetCurrentWorkCycleStageName(
  const Value: string);
begin

  FDocumentMainInformationFormViewModel.CurrentWorkCycleStageName :=
    Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetCurrentWorkCycleStageNumber(
  const Value: Integer);
begin

  FDocumentMainInformationFormViewModel.CurrentWorkCycleStageNumber :=
    Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetNumberPrefix(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.NumberPrefix := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetProductCode(
  const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.ProductCode := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentAuthorIdentity(
  const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.DocumentAuthorIdentity := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentAuthorShortFullName(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.DocumentAuthorShortFullName := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetNumber(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.Number := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentDate(
  const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.DocumentDate := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentId(
  const Value: Variant);
begin

  inherited;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentMainInformationFormViewModel(
  Value: TDocumentMainInformationFormViewModel);
begin

  FreeAndNil(FDocumentMainInformationFormViewModel);

  FDocumentMainInformationFormViewModel := Value;
  
end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentResponsibleViewModel(
  DocumentResponsibleViewModel: TDocumentResponsibleViewModel);
begin

  FDocumentMainInformationFormViewModel.DocumentResponsibleViewModel :=
    DocumentResponsibleViewModel;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetDocumentSignerViewModel(
  DocumentSignerViewModel: TDocumentSignerViewModel);
begin

  FDocumentMainInformationFormViewModel.DocumentSignerViewModel :=
    DocumentSignerViewModel;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetIncomingNumber(
  const Value: String);
begin

  GetNumberPrefixAndMainValue(
    Value,
    IncomingNumberPartsSeparator,
    FIncomingNumberPrefix,
    FIncomingNumberMainValue
  );

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetIsSelfRegistered(
  const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.IsSelfRegistered := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetKind(
  const Value: String);
begin

  inherited;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetKindId(
  const Value: Variant);
begin

  inherited;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetActualSignerName(
  const Value: String);
begin
  inherited;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetName(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.Name := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetNote(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.Note := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetNumberMainValue(
  const Value: String);
begin

  FDocumentMainInformationFormViewModel.NumberMainValue := Value;

end;

procedure TIncomingDocumentMainInformationFormViewModel.SetSigningDate(
  const Value: Variant);
begin

  FDocumentMainInformationFormViewModel.SigningDate := Value;

end;

end.
