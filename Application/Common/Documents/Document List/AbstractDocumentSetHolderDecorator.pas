unit AbstractDocumentSetHolderDecorator;

interface

uses

  DocumentSetHolder,
  AbstractDataSetHolder,
  DB,
  SysUtils;

type

  TAbstractDocumentSetFieldDefsDecorator = class (TDocumentSetFieldDefs)

    private

    protected

      FOriginalDocumentSetFieldDefs: TDocumentSetFieldDefs;

      function GetAuthorIdFieldName: String;
      function GetAuthorNameFieldName: String;
      function GetBaseDocumentIdFieldName: String;
      function GetChargePerformingStatisticsFieldName: String;
      function GetCreationDateFieldName: String;
      function GetCreationDateMonthFieldName: String;
      function GetCreationDateYearFieldName: String;
      function GetCurrentWorkCycleStageNumberFieldName: String;
      function GetKindFieldName: String;
      function GetKindIdFieldName: String;
      function GetNameFieldName: String;
      function GetNumberFieldName: String;
      function GetCurrentWorkCycleStageNameFieldName: String;
      
      procedure SetAuthorIdFieldName(const Value: String);
      procedure SetAuthorNameFieldName(const Value: String);
      procedure SetBaseDocumentIdFieldName(const Value: String);
      procedure SetChargePerformingStatisticsFieldName(const Value: String);
      procedure SetCreationDateFieldName(const Value: String);
      procedure SetCreationDateMonthFieldName(const Value: String);
      procedure SetCreationDateYearFieldName(const Value: String);
      procedure SetCurrentWorkCycleStageNumberFieldName(const Value: String);
      procedure SetKindFieldName(const Value: String);
      procedure SetKindIdFieldName(const Value: String);
      procedure SetNameFieldName(const Value: String);
      procedure SetNumberFieldName(const Value: String);
      procedure SetCurrentWorkCycleStageNameFieldName(const Value: String);
       procedure SetOriginalDocumentSetFieldDefs(
        const Value: TDocumentSetFieldDefs
       );

    public

      constructor Create(OriginalDocumentSetFieldDefs: TDocumentSetFieldDefs);
      
      property BaseDocumentIdFieldName: String
      read GetBaseDocumentIdFieldName write SetBaseDocumentIdFieldName;

      property KindFieldName: String
      read GetKindFieldName write SetKindFieldName;

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property CreationDateFieldName: String
      read GetCreationDateFieldName write SetCreationDateFieldName;

      property CreationDateYearFieldName: String
      read GetCreationDateYearFieldName write SetCreationDateYearFieldName;

      property CreationDateMonthFieldName: String
      read GetCreationDateMonthFieldName write SetCreationDateMonthFieldName;

      property CurrentWorkCycleStageNumberFieldName: String
      read GetCurrentWorkCycleStageNumberFieldName write SetCurrentWorkCycleStageNumberFieldName;

      property CurrentWorkCycleStageNameFieldName: String
      read GetCurrentWorkCycleStageNameFieldName write SetCurrentWorkCycleStageNameFieldName;

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

    public

      property OriginalDocumentSetFieldDefs: TDocumentSetFieldDefs
      read FOriginalDocumentSetFieldDefs write SetOriginalDocumentSetFieldDefs;

  end;
  
  TAbstractDocumentSetHolderDecorator = class (TDocumentSetHolder)

    protected

      FOriginalDocumentSetHolder: TDocumentSetHolder;

    protected

      procedure SetOriginalDocumentSetHolder(OriginalDocumentSetHolder: TDocumentSetHolder);

      procedure SetDataSet(const Value: TDataSet); override;
      procedure SetFieldDefs(const Value: TAbstractDataSetFieldDefs); virtual;

    public

      function GetAuthorIdFieldName: String; override;
      function GetAuthorIdFieldValue: Variant; override;
      function GetAuthorNameFieldName: String; override;
      function GetAuthorNameFieldValue: String; override;
      function GetChargePerformingStatisticsFieldName: String; override;
      function GetChargePerformingStatisticsFieldValue: Variant; override;
      function GetCreationDateFieldName: string; override;
      function GetCreationDateFieldValue: TDateTime; override;
      function GetDocumentDateFieldName: String; override;
      function GetDocumentDateFieldValue: Variant; override;
      function GetCreationDateMonthFieldName: String; override;
      function GetCreationDateMonthFieldValue: Integer; override;
      function GetCreationDateYearFieldName: String; override;
      function GetCreationDateYearFieldValue: Integer; override;
      function GetCurrentWorkCycleStageNameFieldName: String; override;
      function GetCurrentWorkCycleStageNameFieldValue: String; override;
      function GetCurrentWorkCycleStageNumberFieldName: String; override;
      function GetCurrentWorkCycleStageNumberFieldValue: Integer; override;
      function GetKindFieldName: String; override;
      function GetKindFieldValue: String; override;
      function GetKindIdFieldName: String; override;
      function GetKindIdFieldValue: Variant; override;
      function GetNameFieldName: String; override;
      function GetNameFieldValue: String; override;
      function GetNumberFieldName: String; override;
      function GetNumberFieldValue: String; override;
      function GetBaseDocumentIdFieldName: String; override;
      function GetBaseDocumentIdFieldValue: Variant; override;
      function GetDocumentIdFieldName: String; override;
      function GetDocumentIdFieldValue: Variant; override;
      function GetIsSelfRegisteredFieldName: String; override;
      function GetIsSelfRegisteredFieldValue: Variant; override;
      function GetAreApplicationsExistsFieldName: String; override;
      function GetAreApplicationsExistsFieldValue: Variant; override;
      function GetProductCodeFieldName: String; override;
      function GetProductCodeFieldValue: Variant; override;
      function GetDocumentsKindId: Variant; override;

      procedure SetAuthorIdFieldName(const Value: String); override;
      procedure SetAuthorIdFieldValue(const Value: Variant); override;
      procedure SetAuthorNameFieldName(const Value: String); override;
      procedure SetAuthorNameFieldValue(const Value: String); override;
      procedure SetChargePerformingStatisticsFieldName(const Value: String); override;
      procedure SetChargePerformingStatisticsFieldValue(const Value: Variant); override;
      procedure SetCreationDateFieldName(const Value: string); override;
      procedure SetCreationDateFieldValue(const Value: TDateTime); override;
      procedure SetDocumentDateFieldName(const Value: String); override;
      procedure SetDocumentDateFieldValue(const Value: Variant); override;
      procedure SetCreationDateMonthFieldName(const Value: String); override;
      procedure SetCreationDateMonthFieldValue(const Value: Integer); override;
      procedure SetCreationDateYearFieldName(const Value: String); override;
      procedure SetCurrentWorkCycleStageNameFieldName(const Value: String); override;
      procedure SetCurrentWorkCycleStageNameFieldValue(const Value: String); override;
      procedure SetCurrentWorkCycleStageNumberFieldName(const Value: String); override;
      procedure SetCurrentWorkCycleStageNumberFieldValue(const Value: Integer); override;
      procedure SetKindFieldName(const Value: String); override;
      procedure SetKindFieldValue(const Value: String); override;
      procedure SetKindIdFieldName(const Value: String); override;
      procedure SetKindIdFieldValue(const Value: Variant); override;
      procedure SetNameFieldName(const Value: String); override;
      procedure SetNameFieldValue(const Value: String); override;
      procedure SetNumberFieldName(const Value: String); override;
      procedure SetNumberFieldValue(const Value: String); override;
      procedure SetBaseDocumentIdFieldName(const Value: String); override;
      procedure SetBaseDocumentIdFieldValue(const Value: Variant); override;
      procedure SetDocumentIdFieldName(const Value: String); override;
      procedure SetDocumentIdFieldValue(const Value: Variant); override;
      procedure SetIsSelfRegisteredFieldName(const Value: String); override;
      procedure SetIsSelfRegisteredFieldValue(const Value: Variant); override;
      procedure SetCreationDateYearFieldValue(const Value: Integer); override;
      procedure SetAreApplicationsExistsFieldName(const Value: String); override;
      procedure SetAreApplicationsExistsFieldValue(const Value: Variant); override;
      procedure SetProductCodeFieldName(const Value: String); override;
      procedure SetProductCodeFieldValue(const Value: Variant); override;
      procedure SetDocumentsKindId(const Value: Variant); override;

    public

      constructor CreateFrom(OriginalDocumentSetHolder: TDocumentSetHolder);
      
      destructor Destroy; override;

      function GetNestedDocumentSetHolderByType(
        DocumentSetHolderType: TDocumentSetHolderClass
      ): TDocumentSetHolder;
      
      property OriginalDocumentSetHolder: TDocumentSetHolder
      read FOriginalDocumentSetHolder write SetOriginalDocumentSetHolder;
      
  end;

  TAbstractDocumentSetHolderDecoratorClass = class of TAbstractDocumentSetHolderDecorator;
  
implementation

{ TAbstractDocumentSetHolderDecorator }

constructor TAbstractDocumentSetHolderDecorator.CreateFrom(
  OriginalDocumentSetHolder: TDocumentSetHolder);
begin

  inherited Create;

  Self.OriginalDocumentSetHolder := OriginalDocumentSetHolder;
  
end;

destructor TAbstractDocumentSetHolderDecorator.Destroy;
begin

  FDataSet := nil;
  
  FreeAndNil(FOriginalDocumentSetHolder);

  inherited;

end;

function TAbstractDocumentSetHolderDecorator.GetAreApplicationsExistsFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.AreApplicationsExistsFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetAreApplicationsExistsFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.AreApplicationsExistsFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetAuthorIdFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.AuthorIdFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetAuthorIdFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.AuthorIdFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetAuthorNameFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.AuthorNameFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetAuthorNameFieldValue: String;
begin

  Result := FOriginalDocumentSetHolder.AuthorNameFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetBaseDocumentIdFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.BaseDocumentIdFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetBaseDocumentIdFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.BaseDocumentIdFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetChargePerformingStatisticsFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.ChargePerformingStatisticsFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetChargePerformingStatisticsFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.ChargePerformingStatisticsFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateFieldName: string;
begin

  Result := FOriginalDocumentSetHolder.CreationDateFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateFieldValue: TDateTime;
begin

  Result := FOriginalDocumentSetHolder.CreationDateFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateMonthFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.CreationDateMonthFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateMonthFieldValue: Integer;
begin

  Result := FOriginalDocumentSetHolder.CreationDateMonthFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateYearFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.CreationDateYearFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCreationDateYearFieldValue: Integer;
begin

  Result := FOriginalDocumentSetHolder.CreationDateYearFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetCurrentWorkCycleStageNameFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.CurrentWorkCycleStageNameFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCurrentWorkCycleStageNameFieldValue: String;
begin

  Result := FOriginalDocumentSetHolder.CurrentWorkCycleStageNameFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetCurrentWorkCycleStageNumberFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.CurrentWorkCycleStageNumberFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetCurrentWorkCycleStageNumberFieldValue: Integer;
begin

  Result := FOriginalDocumentSetHolder.CurrentWorkCycleStageNumberFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetDocumentDateFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.DocumentDateFieldName;
  
end;

function TAbstractDocumentSetHolderDecorator.GetDocumentDateFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.DocumentDateFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetDocumentIdFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.DocumentIdFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetDocumentIdFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.DocumentIdFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetDocumentsKindId: Variant;
begin

  Result := FOriginalDocumentSetHolder.DocumentsKindId;
  
end;

function TAbstractDocumentSetHolderDecorator.GetIsSelfRegisteredFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.IsSelfRegisteredFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetIsSelfRegisteredFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.IsSelfRegisteredFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetKindFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.KindFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetKindFieldValue: String;
begin

  Result := FOriginalDocumentSetHolder.KindFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetKindIdFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.KindIdFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetKindIdFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.KindIdFieldValue;

end;

function TAbstractDocumentSetHolderDecorator.GetNameFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.NameFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetNameFieldValue: String;
begin

  Result := FOriginalDocumentSetHolder.NameFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetNestedDocumentSetHolderByType(
  DocumentSetHolderType: TDocumentSetHolderClass): TDocumentSetHolder;
begin

  Result := Self;

  while Assigned(Result) and not Result.InheritsFrom(DocumentSetHolderType)
  do begin

    if Result is TAbstractDocumentSetHolderDecorator then begin

      Result := TAbstractDocumentSetHolderDecorator(Result).OriginalDocumentSetHolder;

      Continue;
        
    end

    else begin

      Result := nil;

      Exit;
        
    end;

  end;

end;

function TAbstractDocumentSetHolderDecorator.GetNumberFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.NumberFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetNumberFieldValue: String;
begin

  Result := FOriginalDocumentSetHolder.NumberFieldValue;
  
end;

function TAbstractDocumentSetHolderDecorator.GetProductCodeFieldName: String;
begin

  Result := FOriginalDocumentSetHolder.ProductCodeFieldName;

end;

function TAbstractDocumentSetHolderDecorator.GetProductCodeFieldValue: Variant;
begin

  Result := FOriginalDocumentSetHolder.ProductCodeFieldValue;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetAreApplicationsExistsFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.AreApplicationsExistsFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetAreApplicationsExistsFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.AreApplicationsExistsFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetAuthorIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.AuthorIdFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetAuthorIdFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.AuthorIdFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetAuthorNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.AuthorNameFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetAuthorNameFieldValue(
  const Value: String);
begin

  FOriginalDocumentSetHolder.AuthorNameFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetBaseDocumentIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.BaseDocumentIdFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetBaseDocumentIdFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.BaseDocumentIdFieldValue := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetChargePerformingStatisticsFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.ChargePerformingStatisticsFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetChargePerformingStatisticsFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.ChargePerformingStatisticsFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateFieldName(
  const Value: string);
begin

  FOriginalDocumentSetHolder.CreationDateFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateFieldValue(
  const Value: TDateTime);
begin

  FOriginalDocumentSetHolder.CreationDateFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateMonthFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.CreationDateMonthFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateMonthFieldValue(
  const Value: Integer);
begin

  FOriginalDocumentSetHolder.CreationDateMonthFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateYearFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.CreationDateYearFieldName := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetCreationDateYearFieldValue(
  const Value: Integer);
begin

  FOriginalDocumentSetHolder.CreationDateYearFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCurrentWorkCycleStageNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.CurrentWorkCycleStageNameFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCurrentWorkCycleStageNameFieldValue(
  const Value: String);
begin

  FOriginalDocumentSetHolder.CurrentWorkCycleStageNameFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCurrentWorkCycleStageNumberFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.CurrentWorkCycleStageNumberFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetCurrentWorkCycleStageNumberFieldValue(
  const Value: Integer);
begin

  FOriginalDocumentSetHolder.CurrentWorkCycleStageNumberFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetDataSet(const Value: TDataSet);
begin

  FOriginalDocumentSetHolder.DataSet := Value;

  FDataSet := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetDocumentDateFieldName(
  const Value: String);
begin
  inherited;

end;

procedure TAbstractDocumentSetHolderDecorator.SetDocumentDateFieldValue(
  const Value: Variant);
begin
  inherited;

end;

procedure TAbstractDocumentSetHolderDecorator.SetDocumentIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.DocumentIdFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetDocumentIdFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.DocumentIdFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetDocumentsKindId(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.DocumentsKindId := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetFieldDefs(
  const Value: TAbstractDataSetFieldDefs);
begin

  SetFieldDefs(Value);

  FOriginalDocumentSetHolder.FieldDefs :=
    TAbstractDocumentSetFieldDefsDecorator(Value).OriginalDocumentSetFieldDefs;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetIsSelfRegisteredFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.IsSelfRegisteredFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetIsSelfRegisteredFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.IsSelfRegisteredFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetKindFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.KindFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetKindFieldValue(
  const Value: String);
begin

  FOriginalDocumentSetHolder.KindFieldValue := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetKindIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.KindIdFieldName := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetKindIdFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.KindIdFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.NameFieldName := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetNameFieldValue(
  const Value: String);
begin

  FOriginalDocumentSetHolder.NameFieldValue := Value;

end;

procedure TAbstractDocumentSetHolderDecorator.SetNumberFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.NumberFieldName := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetNumberFieldValue(
  const Value: String);
begin

  FOriginalDocumentSetHolder.NumberFieldValue := Value;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetOriginalDocumentSetHolder(
  OriginalDocumentSetHolder: TDocumentSetHolder);
begin

  FOriginalDocumentSetHolder := OriginalDocumentSetHolder;

  DataSet := FOriginalDocumentSetHolder.DataSet;
  
end;

procedure TAbstractDocumentSetHolderDecorator.SetProductCodeFieldName(
  const Value: String);
begin

  FOriginalDocumentSetHolder.ProductCodeFieldName := Value; 

end;

procedure TAbstractDocumentSetHolderDecorator.SetProductCodeFieldValue(
  const Value: Variant);
begin

  FOriginalDocumentSetHolder.ProductCodeFieldValue := Value;
  
end;

{ TAbstractDocumentSetFieldDefsDecorator }

constructor TAbstractDocumentSetFieldDefsDecorator.Create(
  OriginalDocumentSetFieldDefs: TDocumentSetFieldDefs);
begin

  inherited Create;

  FOriginalDocumentSetFieldDefs := OriginalDocumentSetFieldDefs;
  
end;

function TAbstractDocumentSetFieldDefsDecorator.GetAuthorIdFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.AuthorIdFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetAuthorNameFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.AuthorNameFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetBaseDocumentIdFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.BaseDocumentIdFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetChargePerformingStatisticsFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.ChargePerformingStatisticsFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetCreationDateFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.CreationDateFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetCreationDateMonthFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.CreationDateMonthFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetCreationDateYearFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.CreationDateYearFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetCurrentWorkCycleStageNameFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.CurrentWorkCycleStageNameFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetCurrentWorkCycleStageNumberFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.CurrentWorkCycleStageNumberFieldName;
  
end;

function TAbstractDocumentSetFieldDefsDecorator.GetKindFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.KindFieldName;
  
end;

function TAbstractDocumentSetFieldDefsDecorator.GetKindIdFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.KindIdFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetNameFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.NameFieldName;

end;

function TAbstractDocumentSetFieldDefsDecorator.GetNumberFieldName: String;
begin

  Result := FOriginalDocumentSetFieldDefs.NumberFieldName;
  
end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetAuthorIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.AuthorIdFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetAuthorNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.AuthorNameFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetBaseDocumentIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.BaseDocumentIdFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetChargePerformingStatisticsFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.ChargePerformingStatisticsFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetCreationDateFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.CreationDateFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetCreationDateMonthFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.CreationDateMonthFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetCreationDateYearFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.CreationDateYearFieldName := Value;
  
end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetCurrentWorkCycleStageNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.CurrentWorkCycleStageNameFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetCurrentWorkCycleStageNumberFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.CurrentWorkCycleStageNumberFieldName := Value;
  
end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetKindFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.KindFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetKindIdFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.KindIdFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetNameFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.NameFieldName := Value;

end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetNumberFieldName(
  const Value: String);
begin

  FOriginalDocumentSetFieldDefs.NumberFieldName := Value;
  
end;

procedure TAbstractDocumentSetFieldDefsDecorator.SetOriginalDocumentSetFieldDefs(
  const Value: TDocumentSetFieldDefs);
begin

  FOriginalDocumentSetFieldDefs := Value;

end;

end.
