unit DocumentRecordViewModelDecorator;

interface

uses

  DocumentRecordViewModel,
  SysUtils,
  Classes;

type

  TDocumentRecordViewModelDecorator = class (TDocumentRecordViewModel)

    protected

      FDocumentRecordViewModel: TDocumentRecordViewModel;

      function GetAuthorId: Variant; override;
      function GetAuthorName: String; override;
      function GetCanBeRemoved: Variant; override;
      function GetChargePerformingStatistics: Variant; override;
      function GetDocumentDate: Variant; override;
      function GetCreationDate: TDateTime; override;
      function GetCreationDateMonth: Integer; override;
      function GetCreationDateYear: Integer; override;
      function GetCurrentWorkCycleStageName: String; override;
      function GetCurrentWorkCycleStageNumber: Integer; override;
      function GetDocumentId: Variant; override;
      function GetBaseDocumentId: Variant; override;
      function GetKind: String; override;
      function GetKindId: Variant; override;
      function GetName: String; override;
      function GetProductCode: Variant; override;
      function GetNumber: String; override;
      function GetAreApplicationsExists: Variant; override;
      function GetIsSelfRegistered: Variant; override;

      procedure SetAuthorId(const Value: Variant); override;
      procedure SetAuthorName(const Value: String); override;
      procedure SetCanBeRemoved(const Value: Variant); override;
      procedure SetChargePerformingStatistics(const Value: Variant); override;
      procedure SetDocumentDate(const Value: Variant); override;
      procedure SetCreationDate(const Value: TDateTime); override;
      procedure SetCreationDateMonth(const Value: Integer); override;
      procedure SetCreationDateYear(const Value: Integer); override;
      procedure SetCurrentWorkCycleStageName(const Value: String); override;
      procedure SetCurrentWorkCycleStageNumber(const Value: Integer); override;
      procedure SetDocumentId(const Value: Variant); override;
      procedure SetBaseDocumentId(const Value: Variant); override;
      procedure SetKind(const Value: String); override;
      procedure SetKindId(const Value: Variant); override;
      procedure SetName(const Value: String); override;
      procedure SetNumber(const Value: String); override;
      procedure SetProductCode(const Value: Variant); override;
      procedure SetAreApplicationsExists(const Value: Variant); override;
      procedure SetIsSelfRegistered(const Value: Variant); override;

      procedure SetOriginalDocumentRecordViewModel(
        OriginalDocumentRecordViewModel: TDocumentRecordViewModel
      );

    public

      destructor Destroy; override;

      constructor Create; overload; override;
      constructor Create(DocumentRecordViewModel: TDocumentRecordViewModel); overload; virtual;

      function GetNestedDocumentRecordViewModelByType(
        DocumentRecordViewModelType: TDocumentRecordViewModelClass
      ): TDocumentRecordViewModel;
      
      property OriginalDocumentRecordViewModel: TDocumentRecordViewModel
      read FDocumentRecordViewModel write SetOriginalDocumentRecordViewModel;
      
  end;

  
implementation

{ TDocumentRecordViewModelDecorator }

constructor TDocumentRecordViewModelDecorator.Create(
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  FDocumentRecordViewModel := DocumentRecordViewModel;

  inherited Create;
  
end;

constructor TDocumentRecordViewModelDecorator.Create;
begin

  inherited Create;

end;

destructor TDocumentRecordViewModelDecorator.Destroy;
begin

  FreeAndNil(FDocumentRecordViewModel);
  
  inherited;

end;

function TDocumentRecordViewModelDecorator.GetAreApplicationsExists: Variant;
begin

  Result := FDocumentRecordViewModel.AreApplicationsExists;

end;

function TDocumentRecordViewModelDecorator.GetAuthorId: Variant;
begin

  Result := FDocumentRecordViewModel.AuthorId;
  
end;

function TDocumentRecordViewModelDecorator.GetAuthorName: String;
begin

  Result := FDocumentRecordViewModel.AuthorName;

end;

function TDocumentRecordViewModelDecorator.GetBaseDocumentId: Variant;
begin

  Result := FDocumentRecordViewModel.BaseDocumentId;

end;

function TDocumentRecordViewModelDecorator.GetCanBeRemoved: Variant;
begin

  Result := FDocumentRecordViewModel.CanBeRemoved;

end;

function TDocumentRecordViewModelDecorator.GetChargePerformingStatistics: Variant;
begin

  Result := FDocumentRecordViewModel.ChargePerformingStatistics;

end;

function TDocumentRecordViewModelDecorator.GetCreationDate: TDateTime;
begin

  Result := FDocumentRecordViewModel.CreationDate;
  
end;

function TDocumentRecordViewModelDecorator.GetCreationDateMonth: Integer;
begin

  Result := FDocumentRecordViewModel.CreationDateMonth;

end;

function TDocumentRecordViewModelDecorator.GetCreationDateYear: Integer;
begin

  Result := FDocumentRecordViewModel.CreationDateYear;

end;

function TDocumentRecordViewModelDecorator.GetCurrentWorkCycleStageName: String;
begin

  Result := FDocumentRecordViewModel.CurrentWorkCycleStageName;

end;

function TDocumentRecordViewModelDecorator.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FDocumentRecordViewModel.CurrentWorkCycleStageNumber;

end;

function TDocumentRecordViewModelDecorator.GetDocumentDate: Variant;
begin

  Result := FDocumentRecordViewModel.DocumentDate;
  
end;

function TDocumentRecordViewModelDecorator.GetDocumentId: Variant;
begin

  Result := FDocumentRecordViewModel.DocumentId;
  
end;

function TDocumentRecordViewModelDecorator.GetIsSelfRegistered: Variant;
begin

  Result := FDocumentRecordViewModel.IsSelfRegistered;
  
end;

function TDocumentRecordViewModelDecorator.GetKind: String;
begin

  Result := FDocumentRecordViewModel.Kind;

end;

function TDocumentRecordViewModelDecorator.GetKindId: Variant;
begin

  Result := FDocumentRecordViewModel.KindId;
  
end;

function TDocumentRecordViewModelDecorator.GetName: String;
begin

  Result := FDocumentRecordViewModel.Name;
  
end;

function TDocumentRecordViewModelDecorator.GetNestedDocumentRecordViewModelByType(
  DocumentRecordViewModelType: TDocumentRecordViewModelClass
): TDocumentRecordViewModel;
begin

  Result := Self;

  while Assigned(Result) and not Result.InheritsFrom(DocumentRecordViewModelType)
  do begin

    if Result is TDocumentRecordViewModelDecorator then begin

      Result := TDocumentRecordViewModelDecorator(Result).OriginalDocumentRecordViewModel;

      Continue;
        
    end

    else begin

      Result := nil;

      Exit;
        
    end;

  end;

end;

function TDocumentRecordViewModelDecorator.GetNumber: String;
begin

  Result := FDocumentRecordViewModel.Number;

end;

function TDocumentRecordViewModelDecorator.GetProductCode: Variant;
begin

  Result := FDocumentRecordViewModel.ProductCode;
  
end;

procedure TDocumentRecordViewModelDecorator.SetAreApplicationsExists(
  const Value: Variant);
begin

  FDocumentRecordViewModel.AreApplicationsExists := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetAuthorId(const Value: Variant);
begin

  FDocumentRecordViewModel.AuthorId := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetAuthorName(const Value: String);
begin

  FDocumentRecordViewModel.AuthorName := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetBaseDocumentId(
  const Value: Variant);
begin

  FDocumentRecordViewModel.BaseDocumentId := Value;
  
end;

procedure TDocumentRecordViewModelDecorator.SetCanBeRemoved(
  const Value: Variant);
begin

  FDocumentRecordViewModel.CanBeRemoved := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetChargePerformingStatistics(
  const Value: Variant);
begin

  FDocumentRecordViewModel.ChargePerformingStatistics := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetCreationDate(
  const Value: TDateTime);
begin

  FDocumentRecordViewModel.CreationDate := Value;
  
end;

procedure TDocumentRecordViewModelDecorator.SetCreationDateMonth(
  const Value: Integer);
begin

  FDocumentRecordViewModel.CreationDateMonth := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetCreationDateYear(
  const Value: Integer);
begin

  FDocumentRecordViewModel.CreationDateYear := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetCurrentWorkCycleStageName(
  const Value: String);
begin

  FDocumentRecordViewModel.CurrentWorkCycleStageName := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetCurrentWorkCycleStageNumber(
  const Value: Integer);
begin

  FDocumentRecordViewModel.CurrentWorkCycleStageNumber := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetDocumentDate(
  const Value: Variant);
begin

  FDocumentRecordViewModel.DocumentDate := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetDocumentId(const Value: Variant);
begin

  FDocumentRecordViewModel.DocumentId := Value;
  
end;

procedure TDocumentRecordViewModelDecorator.SetIsSelfRegistered(
  const Value: Variant);
begin

  FDocumentRecordViewModel.IsSelfRegistered := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetKind(const Value: String);
begin

  FDocumentRecordViewModel.Kind := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetKindId(const Value: Variant);
begin

  FDocumentRecordViewModel.KindId := Value;

end;

procedure TDocumentRecordViewModelDecorator.SetName(const Value: String);
begin

  FDocumentRecordViewModel.Name := Value;
  
end;

procedure TDocumentRecordViewModelDecorator.SetNumber(const Value: String);
begin

  FDocumentRecordViewModel.Number := Value;
  
end;

procedure TDocumentRecordViewModelDecorator.SetOriginalDocumentRecordViewModel(
  OriginalDocumentRecordViewModel: TDocumentRecordViewModel);
begin

  if FDocumentRecordViewModel = OriginalDocumentRecordViewModel then Exit;

  FreeAndNil(FDocumentRecordViewModel);

  FDocumentRecordViewModel := OriginalDocumentRecordViewModel;
  
end;

procedure TDocumentRecordViewModelDecorator.SetProductCode(const Value: Variant);
begin

  FDocumentRecordViewModel.ProductCode := Value;

end;

end.
