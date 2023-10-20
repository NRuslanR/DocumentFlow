unit DocumentsReferenceFormFactory;

interface

uses

  UIDocumentKindResolver,
  UIDocumentKinds,
  SysUtils,
  BaseDocumentsReferenceFormUnit,
  DocumentsReferenceViewModel,
  DocumentsReferenceFormProcessorFactory,
  DocumentsReferenceFormProcessor,
  BaseOutcomingDocumentsReferenceFormUnit,
  BaseIncomingDocumentsReferenceFormUnit,
  BaseApproveableDocumentsReferenceFormUnit,
  Classes,
  DB;

type

  TDocumentsReferenceFormFactory = class

    protected

      FDocumentsReferenceFormProcessorFactory: TDocumentsReferenceFormProcessorFactory;

    protected

      function CreateDocumentsReferenceFormFor(
        UIDocumentKind: TUIDocumentKindClass
      ): TBaseDocumentsReferenceForm;

      function CreateIncomingServiceNotesReferenceForm(
        const UIDocumentKinds: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm;

    protected

      function CreateIncomingDocumentsReferenceForm(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm; virtual;

      function CreateOutcomingDocumentsReferenceForm(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm; virtual;

      function CreateApproveableDocumentsReferenceForm(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm; virtual;

      function CreateOrdinaryDocumentsReferenceForm(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm; virtual;

      function CreatePersonnelOrdersReferenceForm(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
      ): TBaseDocumentsReferenceForm; 

    public

      destructor Destroy; override;
      
      constructor Create(
        DocumentsReferenceFormProcessorFactory: TDocumentsReferenceFormProcessorFactory
      );

      function GetDocumentReferenceFormFor(
        UIDocumentKind: TUIDocumentKindClass
      ): TBaseDocumentsReferenceForm; overload;

      function GetDocumentReferenceFormFor(
        UIDocumentKind: TUIDocumentKindClass;
        ViewModel: TDocumentsReferenceViewModel
      ): TBaseDocumentsReferenceForm; overload;

  end;

implementation

uses

  unIncomingServiceNotesReferenceForm,
  unOutcomingServiceNotesReferenceForm,
  unApproveableServiceNotesReferenceForm,
  unPersonnelOrdersReferenceForm,
  AuxZeosFunctions,
  ZConnection,
  AuxDebugFunctionsUnit;

{ TDocumentsReferenceFormFactory }

function TDocumentsReferenceFormFactory.GetDocumentReferenceFormFor(
  UIDocumentKind: TUIDocumentKindClass;
  ViewModel: TDocumentsReferenceViewModel
): TBaseDocumentsReferenceForm;
begin

  Result := GetDocumentReferenceFormFor(UIDocumentKind);

  Result.ViewModel := ViewModel;

end;

function TDocumentsReferenceFormFactory.GetDocumentReferenceFormFor(
  UIDocumentKind: TUIDocumentKindClass): TBaseDocumentsReferenceForm;
begin

  Result := CreateDocumentsReferenceFormFor(UIDocumentKind);

end;

function TDocumentsReferenceFormFactory.
  CreateDocumentsReferenceFormFor(
    UIDocumentKind: TUIDocumentKindClass
  ): TBaseDocumentsReferenceForm;
var
    DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
begin

  DocumentsReferenceFormProcessor :=
    FDocumentsReferenceFormProcessorFactory
      .CreateDocumentsReferenceFormProcessor(UIDocumentKind);

  if UIDocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) then begin

    Result := TOutcomingServiceNotesReferenceForm.Create(DocumentsReferenceFormProcessor, nil);

  end

  else if UIDocumentKind.InheritsFrom(TUIIncomingServiceNoteKind) then begin

    Result := CreateIncomingServiceNotesReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);

  end

  else if UIDocumentKind.InheritsFrom(TUIApproveableServiceNoteKind) then begin

    Result := TApproveableServiceNotesReferenceForm.Create(DocumentsReferenceFormProcessor, nil);

  end
  
  else if UIDocumentKind.InheritsFrom(TUIPersonnelOrderKind) then begin

    Result := CreatePersonnelOrdersReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);
    
  end

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then begin

    Result := CreateIncomingDocumentsReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);

  end

  else if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
  begin

    Result := CreateOutcomingDocumentsReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);

  end

  else if UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind) then
  begin

    Result := CreateApproveableDocumentsReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);
      
  end

  else if UIDocumentKind.InheritsFrom(TUINativeDocumentKind) then begin

    Result := CreateOrdinaryDocumentsReferenceForm(UIDocumentKind, DocumentsReferenceFormProcessor);
    
  end

  else begin

    raise Exception.Create(
      'Программная ошибка. Не распознан вид документа при ' +
      'создании справочника документов'
    );

  end;

end;

function TDocumentsReferenceFormFactory.
CreateIncomingDocumentsReferenceForm(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
): TBaseDocumentsReferenceForm;
begin

  Result := TBaseIncomingDocumentsReferenceForm.Create(DocumentsReferenceFormProcessor, nil);

end;

function TDocumentsReferenceFormFactory.CreateIncomingServiceNotesReferenceForm(
  const UIDocumentKinds: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor): TBaseDocumentsReferenceForm;
begin

  Result := TIncomingServiceNotesReferenceForm.Create(DocumentsReferenceFormProcessor, nil);
  
end;

function TDocumentsReferenceFormFactory.CreateOrdinaryDocumentsReferenceForm(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
): TBaseDocumentsReferenceForm;
begin

  Result := TBaseDocumentsReferenceForm.Create(DocumentsReferenceFormProcessor, nil);

end;

function TDocumentsReferenceFormFactory.CreateOutcomingDocumentsReferenceForm(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
): TBaseDocumentsReferenceForm;
begin

  Result := TBaseOutcomingDocumentsReferenceForm.Create(DocumentsReferenceFormProcessor, nil);

end;

function TDocumentsReferenceFormFactory.CreatePersonnelOrdersReferenceForm(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
): TBaseDocumentsReferenceForm;
begin

  Result := TPersonnelOrdersReferenceForm.Create(DocumentsReferenceFormProcessor, nil);
  
end;

constructor TDocumentsReferenceFormFactory.Create(
  DocumentsReferenceFormProcessorFactory: TDocumentsReferenceFormProcessorFactory);
begin

  inherited Create;

  FDocumentsReferenceFormProcessorFactory := DocumentsReferenceFormProcessorFactory;

end;

destructor TDocumentsReferenceFormFactory.Destroy;
begin

  FreeAndNil(FDocumentsReferenceFormProcessorFactory);
  
  inherited;

end;

function TDocumentsReferenceFormFactory.CreateApproveableDocumentsReferenceForm(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
): TBaseDocumentsReferenceForm;
begin

  Result := TBaseApproveableDocumentsReferenceForm.Create(DocumentsReferenceFormProcessor, nil);
  
end;

end.
