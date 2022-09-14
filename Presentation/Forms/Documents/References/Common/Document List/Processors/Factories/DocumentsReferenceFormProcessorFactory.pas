unit DocumentsReferenceFormProcessorFactory;

interface

uses

  DocumentsReferenceFormProcessor,
  DocumentsReferenceFormProcessorDecorator,
  IncomingDocumentsReferenceFormProcessor,
  OutcomingDocumentsReferenceFormProcessor,
  ApproveableDocumentsReferenceFormProcessor,
  UIDocumentKinds,
  SysUtils;

type

  TDocumentsReferenceFormProcessorFactory = class

    protected

      function CreateBaseDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; 

      function CreateOrdinaryDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;

      function CreateOutcomingDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;

      function CreateOutcomingServiceNotesReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;

      function CreateIncomingDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;
      
      function CreateApproveableDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;

      function CreatePersonnelOrdersReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor; virtual;
      
    public

      function CreateDocumentsReferenceFormProcessor(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentsReferenceFormProcessor;

  end;

implementation

uses

  PersonnelOrdersReferenceFormProcessor;
  
{ TDocumentsReferenceFormProcessorFactory }

function TDocumentsReferenceFormProcessorFactory.
  CreateDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  if UIDocumentKind.InheritsFrom(TUIPersonnelOrderKind) then
    Result := CreatePersonnelOrdersReferenceFormProcessor(UIDocumentKind)

  else if UIDocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) then
    Result := CreateOutcomingServiceNotesReferenceFormProcessor(UIDocumentKind)
    
  else if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
    Result := CreateOutcomingDocumentsReferenceFormProcessor(UIDocumentKind)

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then
    Result := CreateIncomingDocumentsReferenceFormProcessor(UIDocumentKind)

  else if UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind) then
    Result := CreateApproveableDocumentsReferenceFormProcessor(UIDocumentKind)

  else if UIDocumentKind.InheritsFrom(TUINativeDocumentKind) then
    Result := CreateOrdinaryDocumentsReferenceFormProcessor(UIDocumentKind)
       
  else begin

    Raise Exception.CreateFmt(
      'Программная ошибка. Не найден процессор ' +
      'для справочника документов типа %s',
      [
        UIDocumentKind.ClassName
      ]
    );
    
  end;
  
end;

function TDocumentsReferenceFormProcessorFactory.
  CreateApproveableDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TApproveableDocumentsReferenceFormProcessor.Create(
      CreateBaseDocumentsReferenceFormProcessor(UIDocumentKind)
    );

  Result.Options.ChargesPerformingStatisticsFieldRequired(False);

end;

function TDocumentsReferenceFormProcessorFactory.
  CreateIncomingDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TIncomingDocumentsReferenceFormProcessor.Create(
      CreateBaseDocumentsReferenceFormProcessor(UIDocumentKind)
    );
  
end;

function TDocumentsReferenceFormProcessorFactory.
  CreateOrdinaryDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result := CreateBaseDocumentsReferenceFormProcessor(UIDocumentKind);

end;

function TDocumentsReferenceFormProcessorFactory.
  CreateOutcomingDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TOutcomingDocumentsReferenceFormProcessor.Create(
      CreateBaseDocumentsReferenceFormProcessor(UIDocumentKind)
    );
  
end;

function TDocumentsReferenceFormProcessorFactory.CreateOutcomingServiceNotesReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass
): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TOutcomingDocumentsReferenceFormProcessor.Create(
      CreateBaseDocumentsReferenceFormProcessor(UIDocumentKind)
    );

  Result.Options.IsSelfRegisteredFieldRequired(True);

end;

function TDocumentsReferenceFormProcessorFactory.CreatePersonnelOrdersReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result := TPersonnelOrdersReferenceFormProcessor.Create;
  
end;

function TDocumentsReferenceFormProcessorFactory.CreateBaseDocumentsReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result := TDocumentsReferenceFormProcessor.Create;
  
end;

end.
