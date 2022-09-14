unit DocumentSetHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentSetFieldDefs = class (TAbstractDataSetFieldDefs)

    protected

      function GetDocumentIdFieldName: String;
      procedure SetDocumentIdFieldName(const Value: String);

    public

      destructor Destroy; override;

    public

      property DocumentIdFieldName: String
      read GetDocumentIdFieldName write SetDocumentIdFieldName;
      
    public

      BaseDocumentIdFieldName: String;
      KindFieldName: String;
      KindIdFieldName: String;
      CreationDateFieldName: String;
      DocumentDateFieldName: String;
      CreationDateYearFieldName: String;
      CreationDateMonthFieldName: String;
      CurrentWorkCycleStageNumberFieldName: String;
      CurrentWorkCycleStageNameFieldName: String;
      NumberFieldName: String;
      NameFieldName: String;
      AuthorIdFieldName: String;
      AuthorNameFieldName: String;
      ChargePerformingStatisticsFieldName: String;
      IsSelfRegisteredFieldName: String;
      AreApplicationsExistsFieldName: String;
      ProductCodeFieldName: String;

  end;

  TDocumentSetFieldDefsClass = class of TDocumentSetFieldDefs;

  TDocumentSetHolder = class (TAbstractDataSetHolder)

    protected

      FDocumentsKindId: Variant;
      FAsSelfRegisteredMarkingAllowed: Boolean;
    
    protected

      function GetAuthorIdFieldName: String; virtual;
      function GetAuthorIdFieldValue: Variant; virtual;
      function GetAuthorNameFieldName: String; virtual;
      function GetAuthorNameFieldValue: String; virtual;
      function GetChargePerformingStatisticsFieldName: String; virtual;
      function GetChargePerformingStatisticsFieldValue: Variant; virtual;
      function GetCreationDateFieldName: string; virtual;
      function GetCreationDateFieldValue: TDateTime; virtual;
      function GetDocumentDateFieldName: String; virtual;
      function GetDocumentDateFieldValue: Variant; virtual;
      function GetCreationDateMonthFieldName: String; virtual;
      function GetCreationDateMonthFieldValue: Integer; virtual;
      function GetCreationDateYearFieldName: String; virtual;
      function GetCreationDateYearFieldValue: Integer; virtual;
      function GetCurrentWorkCycleStageNameFieldName: String; virtual;
      function GetCurrentWorkCycleStageNameFieldValue: String; virtual;
      function GetCurrentWorkCycleStageNumberFieldName: String; virtual;
      function GetCurrentWorkCycleStageNumberFieldValue: Integer; virtual;
      function GetKindFieldName: String; virtual;
      function GetKindFieldValue: String; virtual;
      function GetKindIdFieldName: String; virtual;
      function GetKindIdFieldValue: Variant; virtual;
      function GetNameFieldName: String; virtual;
      function GetNameFieldValue: String; virtual;
      function GetNumberFieldName: String; virtual;
      function GetNumberFieldValue: String; virtual;
      function GetBaseDocumentIdFieldName: String; virtual;
      function GetBaseDocumentIdFieldValue: Variant; virtual;
      function GetDocumentIdFieldName: String; virtual;
      function GetDocumentIdFieldValue: Variant; virtual;
      function GetIsSelfRegisteredFieldName: String; virtual;
      function GetIsSelfRegisteredFieldValue: Variant; virtual;
      function GetDocumentSetFieldDefs: TDocumentSetFieldDefs; virtual;
      function GetAreApplicationsExistsFieldName: String; virtual;
      function GetAreApplicationsExistsFieldValue: Variant; virtual;
      function GetProductCodeFieldName: String; virtual;
      function GetProductCodeFieldValue: Variant; virtual;
      function GetDocumentsKindId: Variant; virtual;

      procedure SetAuthorIdFieldName(const Value: String); virtual;
      procedure SetAuthorIdFieldValue(const Value: Variant); virtual;
      procedure SetAuthorNameFieldName(const Value: String); virtual;
      procedure SetAuthorNameFieldValue(const Value: String); virtual;
      procedure SetChargePerformingStatisticsFieldName(const Value: String); virtual;
      procedure SetChargePerformingStatisticsFieldValue(const Value: Variant); virtual;
      procedure SetCreationDateFieldName(const Value: string); virtual;
      procedure SetDocumentDateFieldName(const Value: String); virtual;
      procedure SetDocumentDateFieldValue(const Value: Variant); virtual;
      procedure SetCreationDateFieldValue(const Value: TDateTime); virtual;
      procedure SetCreationDateMonthFieldName(const Value: String); virtual;
      procedure SetCreationDateMonthFieldValue(const Value: Integer); virtual;
      procedure SetCreationDateYearFieldName(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNameFieldName(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNameFieldValue(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNumberFieldName(const Value: String); virtual;
      procedure SetCurrentWorkCycleStageNumberFieldValue(const Value: Integer); virtual;
      procedure SetKindFieldName(const Value: String); virtual;
      procedure SetKindFieldValue(const Value: String); virtual;
      procedure SetKindIdFieldName(const Value: String); virtual;
      procedure SetKindIdFieldValue(const Value: Variant); virtual;
      procedure SetNameFieldName(const Value: String); virtual;
      procedure SetNameFieldValue(const Value: String); virtual;
      procedure SetNumberFieldName(const Value: String); virtual;
      procedure SetNumberFieldValue(const Value: String); virtual;
      procedure SetBaseDocumentIdFieldName(const Value: String); virtual;
      procedure SetBaseDocumentIdFieldValue(const Value: Variant); virtual;
      procedure SetDocumentIdFieldName(const Value: String); virtual;
      procedure SetDocumentIdFieldValue(const Value: Variant); virtual;
      procedure SetCreationDateYearFieldValue(const Value: Integer); virtual;
      procedure SetIsSelfRegisteredFieldName(const Value: String); virtual;
      procedure SetIsSelfRegisteredFieldValue(const Value: Variant); virtual;
      procedure SetDocumentFieldDefs(const Value: TDocumentSetFieldDefs); virtual;
      procedure SetAreApplicationsExistsFieldName(const Value: String); virtual;
      procedure SetAreApplicationsExistsFieldValue(const Value: Variant); virtual;
      procedure SetProductCodeFieldName(const Value: String); virtual;
      procedure SetProductCodeFieldValue(const Value: Variant); virtual;
      procedure SetDocumentsKindId(const Value: Variant); virtual;
      
      function GetDocumentSet: TDataSet; virtual;
      procedure SetDocumentSet(const Value: TDataSet); virtual;
    
    public

      destructor Destroy; override;
      
      constructor Create; override;
      constructor CreateFrom(DataSet: TDataSet); overload; override;
      constructor CreateFrom(DataSet: TDataSet; FieldDefs: TAbstractDataSetFieldDefs); overload; override;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

      property DocumentsKindId: Variant
      read GetDocumentsKindId write SetDocumentsKindId;
      
      property DataSet: TDataSet
      read GetDocumentSet write SetDocumentSet;
      
    public

      property DocumentIdFieldName: String
      read GetDocumentIdFieldName write SetDocumentIdFieldName;

      property BaseDocumentIdFieldName: String
      read GetBaseDocumentIdFieldName write SetBaseDocumentIdFieldName;
      
      property KindFieldName: String
      read GetKindFieldName write SetKindFieldName;

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property CreationDateFieldName: string
      read GetCreationDateFieldName write SetCreationDateFieldName;

      property DocumentDateFieldName: String
      read GetDocumentDateFieldName write SetDocumentDateFieldName;
      
      property CreationDateYearFieldName: String
      read GetCreationDateYearFieldName write SetCreationDateYearFieldName;

      property CreationDateMonthFieldName: String
      read GetCreationDateMonthFieldName write SetCreationDateMonthFieldName;
      
      property CurrentWorkCycleStageNumberFieldName: String
      read GetCurrentWorkCycleStageNumberFieldName
      write SetCurrentWorkCycleStageNumberFieldName;
      
      property CurrentWorkCycleStageNameFieldName: String
      read GetCurrentWorkCycleStageNameFieldName
      write SetCurrentWorkCycleStageNameFieldName;
      
      property NumberFieldName: String
      read GetNumberFieldName write SetNumberFieldName;
      
      property NameFieldName: String
      read GetNameFieldName write SetNameFieldName;

      property AuthorIdFieldName: String
      read GetAuthorIdFieldName write SetAuthorIdFieldName;

      property AuthorNameFieldName: String
      read GetAuthorNameFieldName write SetAuthorNameFieldName;

      property ChargePerformingStatisticsFieldName: String
      read GetChargePerformingStatisticsFieldName
      write SetChargePerformingStatisticsFieldName;

      property IsSelfRegisteredFieldName: String
      read GetIsSelfRegisteredFieldName write SetIsSelfRegisteredFieldName;

      property AreApplicationsExistsFieldName: String
      read GetAreApplicationsExistsFieldName write SetAreApplicationsExistsFieldName;

      property ProductCodeFieldName: String
      read GetProductCodeFieldName write SetProductCodeFieldName;
      
    public

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue write SetDocumentIdFieldValue;

      property BaseDocumentIdFieldValue: Variant
      read GetBaseDocumentIdFieldValue write SetBaseDocumentIdFieldValue;
      
      property KindFieldValue: String
      read GetKindFieldValue write SetKindFieldValue;

      property KindIdFieldValue: Variant
      read GetKindIdFieldValue write SetKindIdFieldValue;

      property CreationDateFieldValue: TDateTime
      read GetCreationDateFieldValue write SetCreationDateFieldValue;

      property DocumentDateFieldValue: Variant
      read GetDocumentDateFieldValue write SetDocumentDateFieldValue;
      
      property CreationDateYearFieldValue: Integer
      read GetCreationDateYearFieldValue write SetCreationDateYearFieldValue;

      property CreationDateMonthFieldValue: Integer
      read GetCreationDateMonthFieldValue write SetCreationDateMonthFieldValue;
      
      property CurrentWorkCycleStageNumberFieldValue: Integer
      read GetCurrentWorkCycleStageNumberFieldValue
      write SetCurrentWorkCycleStageNumberFieldValue;
      
      property CurrentWorkCycleStageNameFieldValue: String
      read GetCurrentWorkCycleStageNameFieldValue
      write SetCurrentWorkCycleStageNameFieldValue;
      
      property NumberFieldValue: String
      read GetNumberFieldValue write SetNumberFieldValue;
      
      property NameFieldValue: String
      read GetNameFieldValue write SetNameFieldValue;

      property AuthorIdFieldValue: Variant
      read GetAuthorIdFieldValue write SetAuthorIdFieldValue;

      property AuthorNameFieldValue: String
      read GetAuthorNameFieldValue write SetAuthorNameFieldValue;

      property ChargePerformingStatisticsFieldValue: Variant
      read GetChargePerformingStatisticsFieldValue
      write SetChargePerformingStatisticsFieldValue;

      property IsSelfRegisteredFieldValue: Variant
      read GetIsSelfRegisteredFieldValue write SetIsSelfRegisteredFieldValue;

      property AreApplicationsExistsFieldValue: Variant
      read GetAreApplicationsExistsFieldValue write SetAreApplicationsExistsFieldValue;

      property ProductCodeFieldValue: Variant
      read GetProductCodeFieldValue write SetProductCodeFieldValue;
      
    public

      property AsSelfRegisteredMarkingAllowed: Boolean
      read FAsSelfRegisteredMarkingAllowed
      write FAsSelfRegisteredMarkingAllowed;
      
    public

      property FieldDefs: TDocumentSetFieldDefs
      read GetDocumentSetFieldDefs write SetDocumentFieldDefs;

  end;

  TDocumentSetHolderClass = class of TDocumentSetHolder;
  
implementation

uses

  Variants;
  
{ TDocumentSetHolder }

constructor TDocumentSetHolder.Create;
begin

  inherited;

end;

constructor TDocumentSetHolder.CreateFrom(DataSet: TDataSet);
begin

  inherited CreateFrom(DataSet);

end;

constructor TDocumentSetHolder.CreateFrom(
  DataSet: TDataSet;
  FieldDefs: TAbstractDataSetFieldDefs
);
begin

  inherited CreateFrom(DataSet, FieldDefs);
  
end;

destructor TDocumentSetHolder.Destroy;
begin

  FreeAndNil(FDataSet);
  
  inherited;

end;

function TDocumentSetHolder.GetAreApplicationsExistsFieldName: String;
begin

  Result := FieldDefs.AreApplicationsExistsFieldName;
  
end;

function TDocumentSetHolder.GetAreApplicationsExistsFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(AreApplicationsExistsFieldName, Null);
  
end;

function TDocumentSetHolder.GetAuthorIdFieldName: String;
begin

  Result := FieldDefs.AuthorIdFieldName;

end;

function TDocumentSetHolder.GetAuthorIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(AuthorIdFieldName, Null);

end;

function TDocumentSetHolder.GetAuthorNameFieldName: String;
begin

  Result := FieldDefs.AuthorNameFieldName;

end;

function TDocumentSetHolder.GetAuthorNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(AuthorNameFieldName, '');
  
end;

function TDocumentSetHolder.GetBaseDocumentIdFieldName: String;
begin

  Result := FieldDefs.BaseDocumentIdFieldName;

end;

function TDocumentSetHolder.GetBaseDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(BaseDocumentIdFieldName, Null);
  
end;

function TDocumentSetHolder.GetChargePerformingStatisticsFieldName: String;
begin

  Result := FieldDefs.ChargePerformingStatisticsFieldName;

end;

function TDocumentSetHolder.GetChargePerformingStatisticsFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ChargePerformingStatisticsFieldName, Null);

end;

function TDocumentSetHolder.GetCreationDateFieldName: string;
begin

  Result := FieldDefs.CreationDateFieldName;

end;

function TDocumentSetHolder.GetCreationDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(CreationDateFieldName, 0);
  
end;

function TDocumentSetHolder.GetCreationDateMonthFieldName: String;
begin

  Result := FieldDefs.CreationDateMonthFieldName;

end;

function TDocumentSetHolder.GetCreationDateMonthFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(CreationDateMonthFieldName, 0);
  
end;

function TDocumentSetHolder.GetCreationDateYearFieldName: String;
begin

  Result := FieldDefs.CreationDateYearFieldName;

end;

function TDocumentSetHolder.GetCreationDateYearFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(CreationDateYearFieldName, 0);
  
end;

function TDocumentSetHolder.GetCurrentWorkCycleStageNameFieldName: String;
begin

  Result := FieldDefs.CurrentWorkCycleStageNameFieldName;

end;

function TDocumentSetHolder.GetCurrentWorkCycleStageNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(CurrentWorkCycleStageNameFieldName, '');

end;

function TDocumentSetHolder.GetCurrentWorkCycleStageNumberFieldName: String;
begin

  Result := FieldDefs.CurrentWorkCycleStageNumberFieldName;

end;

function TDocumentSetHolder.GetCurrentWorkCycleStageNumberFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(CurrentWorkCycleStageNumberFieldName, 0);

end;

class function TDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentSetFieldDefs;
  
end;

function TDocumentSetHolder.GetDocumentDateFieldName: String;
begin

  Result := FieldDefs.DocumentDateFieldName;
  
end;

function TDocumentSetHolder.GetDocumentDateFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentDateFieldName, Null);

end;

function TDocumentSetHolder.GetDocumentIdFieldName: String;
begin

  Result := FieldDefs.DocumentIdFieldName;

end;

function TDocumentSetHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentIdFieldName, Null);
  
end;

function TDocumentSetHolder.GetDocumentSet: TDataSet;
begin

  Result := inherited DataSet;
  
end;

function TDocumentSetHolder.GetDocumentSetFieldDefs: TDocumentSetFieldDefs;
begin

  Result := TDocumentSetFieldDefs(inherited FieldDefs);
  
end;

function TDocumentSetHolder.GetDocumentsKindId: Variant;
begin

  Result := FDocumentsKindId;

end;

function TDocumentSetHolder.GetKindFieldName: String;
begin

  Result := FieldDefs.KindFieldName;

end;

function TDocumentSetHolder.GetKindFieldValue: String;
begin

  Result := GetDataSetFieldValue(KindFieldName, '');

end;

function TDocumentSetHolder.GetKindIdFieldName: String;
begin

  Result := FieldDefs.KindIdFieldName;

end;

function TDocumentSetHolder.GetKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(KindIdFieldName, null);
  
end;

function TDocumentSetHolder.GetNameFieldName: String;
begin

  Result := FieldDefs.NameFieldName;

end;

function TDocumentSetHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(NameFieldName, '');

end;

function TDocumentSetHolder.GetNumberFieldName: String;
begin

  Result := FieldDefs.NumberFieldName;

end;

function TDocumentSetHolder.GetNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(NumberFieldName, '');
  
end;

function TDocumentSetHolder.GetProductCodeFieldName: String;
begin

  Result := FieldDefs.ProductCodeFieldName;
  
end;

function TDocumentSetHolder.GetProductCodeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ProductCodeFieldName, Null);
  
end;

function TDocumentSetHolder.GetIsSelfRegisteredFieldName: String;
begin

  Result := FieldDefs.IsSelfRegisteredFieldName;

end;

function TDocumentSetHolder.GetIsSelfRegisteredFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IsSelfRegisteredFieldName, Null);

end;

procedure TDocumentSetHolder.SetAreApplicationsExistsFieldName(
  const Value: String);
begin

  FieldDefs.AreApplicationsExistsFieldName := Value;

end;

procedure TDocumentSetHolder.SetAreApplicationsExistsFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(AreApplicationsExistsFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetAuthorIdFieldName(const Value: String);
begin

  FieldDefs.AuthorIdFieldName := Value;

end;

procedure TDocumentSetHolder.SetAuthorIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(AuthorIdFieldName, Value);

end;

procedure TDocumentSetHolder.SetAuthorNameFieldName(const Value: String);
begin

  FieldDefs.AuthorNameFieldName := Value;

end;

procedure TDocumentSetHolder.SetAuthorNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(AuthorNameFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetBaseDocumentIdFieldName(const Value: String);
begin

  FieldDefs.BaseDocumentIdFieldName := Value;

end;

procedure TDocumentSetHolder.SetBaseDocumentIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(BaseDocumentIdFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetChargePerformingStatisticsFieldName(
  const Value: String);
begin

  FieldDefs.ChargePerformingStatisticsFieldName := Value;

end;

procedure TDocumentSetHolder.SetChargePerformingStatisticsFieldValue(
  const Value: Variant);
begin

  if IsDataSetFieldExists(ChargePerformingStatisticsFieldName) then
    SetDataSetFieldValue(ChargePerformingStatisticsFieldName, Value);

end;

procedure TDocumentSetHolder.SetCreationDateFieldName(const Value: string);
begin

  FieldDefs.CreationDateFieldName := Value;

end;

procedure TDocumentSetHolder.SetCreationDateFieldValue(const Value: TDateTime);
begin

  SetDataSetFieldValue(CreationDateFieldName, Value);

end;

procedure TDocumentSetHolder.SetCreationDateMonthFieldName(const Value: String);
begin

  FieldDefs.CreationDateMonthFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetCreationDateMonthFieldValue(
  const Value: Integer);
begin

  SetDataSetFieldValue(CreationDateMonthFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetCreationDateYearFieldName(const Value: String);
begin

  FieldDefs.CreationDateYearFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetCreationDateYearFieldValue(
  const Value: Integer);
begin

  SetDataSetFieldValue(CreationDateYearFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetCurrentWorkCycleStageNameFieldName(
  const Value: String);
begin

  FieldDefs.CurrentWorkCycleStageNameFieldName := Value;

end;

procedure TDocumentSetHolder.SetCurrentWorkCycleStageNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(CurrentWorkCycleStageNameFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetCurrentWorkCycleStageNumberFieldName(
  const Value: String);
begin

  FieldDefs.CurrentWorkCycleStageNumberFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetCurrentWorkCycleStageNumberFieldValue(
  const Value: Integer);
begin

  SetDataSetFieldValue(CurrentWorkCycleStageNumberFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetDocumentDateFieldName(const Value: String);
begin

  FieldDefs.DocumentDateFieldName := Value;

end;

procedure TDocumentSetHolder.SetDocumentDateFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(DocumentDateFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetDocumentFieldDefs(
  const Value: TDocumentSetFieldDefs);
begin

  SetFieldDefs(Value);
  
end;

procedure TDocumentSetHolder.SetDocumentIdFieldName(const Value: String);
begin

  FieldDefs.DocumentIdFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetDocumentIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(DocumentIdFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetDocumentSet(const Value: TDataSet);
begin

  inherited DataSet := Value;

end;

procedure TDocumentSetHolder.SetDocumentsKindId(const Value: Variant);
begin

  FDocumentsKindId := Value;

end;

procedure TDocumentSetHolder.SetKindFieldName(const Value: String);
begin

  FieldDefs.KindFieldName := Value;

end;

procedure TDocumentSetHolder.SetKindFieldValue(const Value: String);
begin

  SetDataSetFieldValue(KindFieldName, Value);

end;

procedure TDocumentSetHolder.SetKindIdFieldName(const Value: String);
begin

  FieldDefs.KindIdFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetKindIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(KindIdFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetNameFieldName(const Value: String);
begin

  FieldDefs.NameFieldName := Value;

end;

procedure TDocumentSetHolder.SetNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(NameFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetNumberFieldName(const Value: String);
begin

  FieldDefs.NumberFieldName := Value;
  
end;

procedure TDocumentSetHolder.SetNumberFieldValue(const Value: String);
begin

  SetDataSetFieldValue(NumberFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetProductCodeFieldName(const Value: String);
begin

  FieldDefs.ProductCodeFieldName := Value;

end;

procedure TDocumentSetHolder.SetProductCodeFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(ProductCodeFieldName, Value);
  
end;

procedure TDocumentSetHolder.SetIsSelfRegisteredFieldName(
  const Value: String);
begin

  FieldDefs.IsSelfRegisteredFieldName := Value;

end;

procedure TDocumentSetHolder.SetIsSelfRegisteredFieldValue(
  const Value: Variant);
begin

  if IsDataSetFieldExists(IsSelfRegisteredFieldName) then
    SetDataSetFieldValue(IsSelfRegisteredFieldName, Value);

end;

{ TDocumentSetFieldDefs }

destructor TDocumentSetFieldDefs.Destroy;
begin

  inherited;

end;

function TDocumentSetFieldDefs.GetDocumentIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentSetFieldDefs.SetDocumentIdFieldName(const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

end.
