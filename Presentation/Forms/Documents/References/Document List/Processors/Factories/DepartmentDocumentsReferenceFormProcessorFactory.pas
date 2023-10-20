unit DepartmentDocumentsReferenceFormProcessorFactory;

interface

uses

  DocumentsReferenceFormProcessorFactory,
  DocumentsReferenceFormProcessor,
  DocumentsReferenceFormProcessorDecorator,
  DepartmentDocumentsReferenceFormProcessor,
  UIDocumentKinds,
  SysUtils;

type

  TDocumentsReferenceFormProcessorCreationMethod =
    function (
      const UIDocumentKind: TUIDocumentKindClass
    ): IDocumentsReferenceFormProcessor;
    
  TDepartmentDocumentsReferenceFormProcessorFactory =
    class (TDocumentsReferenceFormProcessorFactory)

      protected

        function CreateOrdinaryDocumentsReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

        function CreateOutcomingDocumentsReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

        function CreateOutcomingServiceNotesReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

        function CreateIncomingDocumentsReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

        function CreateApproveableDocumentsReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

        function CreatePersonnelOrdersReferenceFormProcessor(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentsReferenceFormProcessor; override;

      private

        function WrapDocumentsReferenceFormProcessorByDefault(
          Processor: IDocumentsReferenceFormProcessor
        ): IDocumentsReferenceFormProcessor;
        
    end;

implementation

{ TDepartmentDocumentsReferenceFormProcessorFactory }

function TDepartmentDocumentsReferenceFormProcessorFactory.CreateApproveableDocumentsReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreateApproveableDocumentsReferenceFormProcessor(UIDocumentKind)
    );
    
end;

function TDepartmentDocumentsReferenceFormProcessorFactory.CreateIncomingDocumentsReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreateIncomingDocumentsReferenceFormProcessor(UIDocumentKind)
    );
    
end;

function TDepartmentDocumentsReferenceFormProcessorFactory.CreateOrdinaryDocumentsReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreateOrdinaryDocumentsReferenceFormProcessor(UIDocumentKind)
    );
    
end;

function TDepartmentDocumentsReferenceFormProcessorFactory.CreateOutcomingDocumentsReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreateOutcomingDocumentsReferenceFormProcessor(UIDocumentKind)
    );
    
end;

function TDepartmentDocumentsReferenceFormProcessorFactory.CreateOutcomingServiceNotesReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreateOutcomingServiceNotesReferenceFormProcessor(UIDocumentKind)
    );
    
end;

function TDepartmentDocumentsReferenceFormProcessorFactory.CreatePersonnelOrdersReferenceFormProcessor(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentsReferenceFormProcessor;
begin

  Result :=
    WrapDocumentsReferenceFormProcessorByDefault(
      inherited CreatePersonnelOrdersReferenceFormProcessor(UIDocumentKind)
    );

end;

function TDepartmentDocumentsReferenceFormProcessorFactory.WrapDocumentsReferenceFormProcessorByDefault(
  Processor: IDocumentsReferenceFormProcessor
): IDocumentsReferenceFormProcessor;
begin

  Result := TDepartmentDocumentsReferenceFormProcessor.Create(Processor);

  Result.Options.ChargesPerformingStatisticsFieldRequired(False);
  
end;

end.
