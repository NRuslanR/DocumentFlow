unit EmployeeDocumentsReferenceFormProcessorFactory;

interface

uses

  DocumentsReferenceFormProcessorFactory,
  DocumentsReferenceFormProcessor,
  IncomingDocumentsReferenceFormProcessor,
  OutcomingDocumentsReferenceFormProcessor,
  ApproveableDocumentsReferenceFormProcessor,
  EmployeeDocumentsReferenceFormProcessor,
  UIDocumentKinds,
  ApplicationServiceRegistries,
  UIDocumentKindMapper,
  DocumentViewingAccountingService,
  SysUtils;

type

  TEmployeeDocumentsReferenceFormProcessorFactory =
    class (TDocumentsReferenceFormProcessorFactory)

      protected

        FUIDocumentKindMapper: IUIDocumentKindMapper;

        function GetDocumentViewingAccountingService(
          const UIDocumentKind: TUIDocumentKindClass
        ): IDocumentViewingAccountingService;
        
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

      public

        constructor Create(
          UIDocumentKindMapper: IUIDocumentKindMapper
        );
        
    end;

implementation
  
{ TEmployeeDocumentsReferenceFormProcessorFactory }

constructor TEmployeeDocumentsReferenceFormProcessorFactory.Create(
  UIDocumentKindMapper: IUIDocumentKindMapper
);
begin

  inherited Create;

  FUIDocumentKindMapper := UIDocumentKindMapper;

end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreateApproveableDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreateApproveableDocumentsReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind),
      TEmployeeDocumentsReferenceFormProcessorOptions
        .Create
          .OwnChargeSheetFieldRequired(False)
          .AllChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
          .AllSubordinateChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
    );

end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreateIncomingDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreateIncomingDocumentsReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind),
      TEmployeeDocumentsReferenceFormProcessorOptions
        .Create
          .OwnChargeSheetFieldRequired(True)
          .AllChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(True)
          )
          .AllSubordinateChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(True)
          )
    );

end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreateOrdinaryDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreateOrdinaryDocumentsReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind)
    );

end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreateOutcomingDocumentsReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreateOutcomingDocumentsReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind),
      TEmployeeDocumentsReferenceFormProcessorOptions
        .Create
          .OwnChargeSheetFieldRequired(False)
          .AllChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
          .AllSubordinateChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
    );
    
end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreateOutcomingServiceNotesReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreateOutcomingServiceNotesReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind),
      TEmployeeDocumentsReferenceFormProcessorOptions
        .Create
          .OwnChargeSheetFieldRequired(False)
          .AllChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
          .AllSubordinateChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
    );

end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  CreatePersonnelOrdersReferenceFormProcessor(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentsReferenceFormProcessor;
begin

  Result :=
    TEmployeeDocumentsReferenceFormProcessor.Create(
      inherited CreatePersonnelOrdersReferenceFormProcessor(UIDocumentKind),
      GetDocumentViewingAccountingService(UIDocumentKind),
      TEmployeeDocumentsReferenceFormProcessorOptions
        .Create
          .OwnChargeSheetFieldRequired(False)
          .AllChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
          .AllSubordinateChargeSheetsPerformedFieldOptions(
            TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(False)
          )
    );
    
end;

function TEmployeeDocumentsReferenceFormProcessorFactory.
  GetDocumentViewingAccountingService(
    const UIDocumentKind: TUIDocumentKindClass
  ): IDocumentViewingAccountingService;
begin

  Result :=
    TApplicationServiceRegistries
      .Current
        .GetAccountingServiceRegistry
          .GetDocumentViewingAccountingService(
            FUIDocumentKindMapper.MapDocumentKindFrom(UIDocumentKind)
          );
        
end;

end.
