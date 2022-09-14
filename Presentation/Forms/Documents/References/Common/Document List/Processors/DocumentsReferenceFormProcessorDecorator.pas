unit DocumentsReferenceFormProcessorDecorator;

interface

uses

  DocumentsReferenceFormProcessor,
  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  DocumentsReferenceForm,
  cxGridCustomTableView,
  SysUtils;

type

  TDocumentsReferenceFormProcessorOptionsDecorator =
    class (TDocumentsReferenceFormProcessorOptions)

      protected

        FInternalOptions: IDocumentsReferenceFormProcessorOptions;
        
      public

        constructor Create; overload; virtual;
        constructor Create(InternalOptions: IDocumentsReferenceFormProcessorOptions); overload; virtual;

        function IsSelfRegisteredFieldRequired: Boolean; overload; override;
        function IsSelfRegisteredFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload; override;

        function ChargesPerformingStatisticsFieldRequired: Boolean; overload; override;
        function ChargesPerformingStatisticsFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload; override;

      public

        property InternalProcessorOptions: IDocumentsReferenceFormProcessorOptions
        read FInternalOptions write FInternalOptions;
        
    end;
    
  TDocumentsReferenceFormProcessorDecorator = class (TDocumentsReferenceFormProcessor)

    protected

      FInternalProcessor: IDocumentsReferenceFormProcessor;

      procedure SetOptions(Value: IDocumentsReferenceFormProcessorOptions); override;

      procedure SetInternalProcessorOptions(
        InternalProcessor: IDocumentsReferenceFormProcessor;
        Options: TDocumentsReferenceFormProcessorOptionsDecorator
      );

      function CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions; override;
      procedure FillDefaultOptions(Options: IDocumentsReferenceFormProcessorOptions); override;
      
    protected

      procedure FillViewModelByDocumentSetRecord(
        RecordViewModel: TDocumentRecordViewModel;
        DocumentSetHolder: TDocumentSetHolder
      ); override;

      procedure FillViewModelByGridRecord(
        RecordViewModel: TDocumentRecordViewModel;
        DocumentsReferenceForm: IDocumentsReferenceForm;
        const GridRecord: TcxCustomGridRecord
      ); override;

      function CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel; override;

      function InternalCreateDocumentRecordViewModelFrom(
        DocumentSetHolder: TDocumentSetHolder;
        const DocumentId: Variant
      ): TDocumentRecordViewModel; override;

      function InternalCreateDocumentRecordViewModelFromGridRecord(
        DocumentsReferenceForm: IDocumentsReferenceForm;
        const GridRecord: TcxCustomGridRecord
      ): TDocumentRecordViewModel; override;

      procedure InternalSetDocumentReferenceFormColumns(
        DocumentsReferenceForm: IDocumentsReferenceForm;
        FieldDefs: TDocumentSetFieldDefs
      ); override;

    public

      constructor Create(
        InternalProcessor: IDocumentsReferenceFormProcessor;
        Options: TDocumentsReferenceFormProcessorOptionsDecorator = nil
      );

      procedure FillDocumentSetRecordByViewModel(
        DocumentSetHolder: TDocumentSetHolder;
        RecordViewModel: TDocumentRecordViewModel
      ); override;

  end;

implementation

uses

  AuxDebugFunctionsUnit;

{ TDocumentsReferenceFormProcessorDecorator }

constructor TDocumentsReferenceFormProcessorDecorator.Create(
  InternalProcessor: IDocumentsReferenceFormProcessor;
  Options: TDocumentsReferenceFormProcessorOptionsDecorator
);
begin

  inherited Create(Options);

  FInternalProcessor := InternalProcessor;

  SetInternalProcessorOptions(
    FInternalProcessor,
    TDocumentsReferenceFormProcessorOptionsDecorator(Self.Options.Self)
  );

end;

function TDocumentsReferenceFormProcessorDecorator.
  InternalCreateDocumentRecordViewModelFrom(
    DocumentSetHolder: TDocumentSetHolder;
    const DocumentId: Variant
  ): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  TDocumentRecordViewModelDecorator(Result).OriginalDocumentRecordViewModel :=
    FInternalProcessor.CreateDocumentRecordViewModelFrom(
      (DocumentSetHolder as TAbstractDocumentSetHolderDecorator).OriginalDocumentSetHolder,
      DocumentId
    );

end;

function TDocumentsReferenceFormProcessorDecorator.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result :=
    inherited InternalCreateDocumentRecordViewModelFromGridRecord(
      DocumentsReferenceForm, GridRecord
    );

  TDocumentRecordViewModelDecorator(Result).OriginalDocumentRecordViewModel :=
    FInternalProcessor.CreateDocumentRecordViewModelFromGridRecord(
      DocumentsReferenceForm, GridRecord
    );

end;

function TDocumentsReferenceFormProcessorDecorator.CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions;
begin

  Result := TDocumentsReferenceFormProcessorOptionsDecorator.Create;
  
end;

function TDocumentsReferenceFormProcessorDecorator.
  CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TDocumentRecordViewModelDecorator.Create;
  
end;

procedure TDocumentsReferenceFormProcessorDecorator.FillDefaultOptions(
  Options: IDocumentsReferenceFormProcessorOptions);
begin

end;

procedure TDocumentsReferenceFormProcessorDecorator.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
begin

  FInternalProcessor.FillDocumentSetRecordByViewModel(
    (DocumentSetHolder as TAbstractDocumentSetHolderDecorator).OriginalDocumentSetHolder,
    (RecordViewModel as TDocumentRecordViewModelDecorator).OriginalDocumentRecordViewModel
  );

end;

procedure TDocumentsReferenceFormProcessorDecorator.FillViewModelByDocumentSetRecord(
  RecordViewModel: TDocumentRecordViewModel;
  DocumentSetHolder: TDocumentSetHolder);
begin

end;

procedure TDocumentsReferenceFormProcessorDecorator.FillViewModelByGridRecord(
  RecordViewModel: TDocumentRecordViewModel;
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord);
begin

end;

procedure TDocumentsReferenceFormProcessorDecorator.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs);
begin

  FInternalProcessor.SetDocumentReferenceFormColumns(
    DocumentsReferenceForm,
    (FieldDefs as TAbstractDocumentSetFieldDefsDecorator).OriginalDocumentSetFieldDefs
  );

end;

procedure TDocumentsReferenceFormProcessorDecorator.SetInternalProcessorOptions(
  InternalProcessor: IDocumentsReferenceFormProcessor;
  Options: TDocumentsReferenceFormProcessorOptionsDecorator);
begin

  if not Assigned(FInternalProcessor) then Exit;

  if Assigned(Options.FInternalOptions) then
    InternalProcessor.Options := Options.FInternalOptions

  else Options.FInternalOptions := InternalProcessor.Options;

end;

procedure TDocumentsReferenceFormProcessorDecorator.SetOptions(
  Value: IDocumentsReferenceFormProcessorOptions
);
begin

  inherited SetOptions(Value);

  if not Assigned(Value) then Exit;

  if not (Value.Self is TDocumentsReferenceFormProcessorOptionsDecorator) then begin

    Raise Exception.CreateFmt(
      '"%s" isn''t ProcessorOptionsDecorator',
      [Value.Self.ClassName]
    );

  end;

  SetInternalProcessorOptions(
    FInternalProcessor,
    TDocumentsReferenceFormProcessorOptionsDecorator(Value.Self)
  );

end;

{ TDocumentsReferenceFormProcessorOptionsDecorator }

constructor TDocumentsReferenceFormProcessorOptionsDecorator.Create;
begin

  inherited;

end;

constructor TDocumentsReferenceFormProcessorOptionsDecorator.Create(
  InternalOptions: IDocumentsReferenceFormProcessorOptions);
begin

  inherited Create;

  FInternalOptions := InternalOptions;

end;

function TDocumentsReferenceFormProcessorOptionsDecorator.ChargesPerformingStatisticsFieldRequired: Boolean;
begin

  Result := FInternalOptions.ChargesPerformingStatisticsFieldRequired;

end;

function TDocumentsReferenceFormProcessorOptionsDecorator.ChargesPerformingStatisticsFieldRequired(
  const Value: Boolean): IDocumentsReferenceFormProcessorOptions;
begin

  FInternalOptions.ChargesPerformingStatisticsFieldRequired(Value);

  Result := Self;

end;

function TDocumentsReferenceFormProcessorOptionsDecorator.IsSelfRegisteredFieldRequired: Boolean;
begin

  Result := FInternalOptions.IsSelfRegisteredFieldRequired;
  
end;

function TDocumentsReferenceFormProcessorOptionsDecorator.IsSelfRegisteredFieldRequired(
  const Value: Boolean): IDocumentsReferenceFormProcessorOptions;
begin

  FInternalOptions.IsSelfRegisteredFieldRequired(Value);

  Result := Self;

end;

end.

