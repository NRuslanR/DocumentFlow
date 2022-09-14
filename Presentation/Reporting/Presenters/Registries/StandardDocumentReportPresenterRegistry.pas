unit StandardDocumentReportPresenterRegistry;

interface

uses

  DocumentReportPresenterRegistry,
  NotPerformedDocumentsReportPresenter,
  UIDocumentKinds,
  DocumentPrintFormPresenter,
  DocumentApprovingSheetPresenter,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  TStandardDocumentReportPresenterRegistry =
    class (TDocumentReportPresenterRegistry)

      private

        FNotPerformedDocumentsReportPresenterRegistry: TTypeObjectRegistry;
        FDocumentPrintFormPresenterRegistry: TTypeObjectRegistry;
        FDocumentApprovingSheetPresenterRegistry: TTypeObjectRegistry;

      public

        destructor Destroy; override;
        constructor Create;

        procedure RegisterNotPerformedDocumentsReportPresenter(
          const UIDocumentKind: TUIDocumentKindClass;
          NotPerformedDocumentsReportPresenter: INotPerformedDocumentsReportPresenter
        ); override;

        function GetNotPerformedDocumentsReportPresenter(
          const UIDocumentKind: TUIDocumentKindClass
        ): INotPerformedDocumentsReportPresenter; override;

      public
      
        procedure RegisterDocumentPrintFormPresenter(
          UIDocumentKind: TUIDocumentKindClass;
          DocumentPrintFormPresenter: IDocumentPrintFormPresenter
        ); override;

        function GetDocumentPrintFormPresenter(
          UIDocumentKind: TUIDocumentKindClass
        ): IDocumentPrintFormPresenter; override;

      public

        procedure RegisterDocumentApprovingSheetPresenter(
          UIDocumentKind: TUIDocumentKindClass;
          DocumentApprovingSheetPresenter: IDocumentApprovingSheetPresenter
        ); override;

        function GetDocumentApprovingSheetPresenter(
          UIDocumentKind: TUIDocumentKindClass
        ): IDocumentApprovingSheetPresenter; override;
        
    end;

implementation

{ TStandardDocumentReportPresenterRegistry }

constructor TStandardDocumentReportPresenterRegistry.Create;
begin

  inherited;

  FDocumentPrintFormPresenterRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
      ltoFreeRegisteredObjectsOnDestroy
    );

  FDocumentPrintFormPresenterRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FNotPerformedDocumentsReportPresenterRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
      ltoFreeRegisteredObjectsOnDestroy
    );

  FNotPerformedDocumentsReportPresenterRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FDocumentApprovingSheetPresenterRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
      ltoFreeRegisteredObjectsOnDestroy
    );

  FDocumentApprovingSheetPresenterRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

end;

destructor TStandardDocumentReportPresenterRegistry.Destroy;
begin

  FreeAndNil(FDocumentPrintFormPresenterRegistry);
  FreeAndNil(FNotPerformedDocumentsReportPresenterRegistry);
  FreeAndNil(FDocumentApprovingSheetPresenterRegistry);
  
  inherited;
  
end;

procedure TStandardDocumentReportPresenterRegistry.
  RegisterNotPerformedDocumentsReportPresenter(
    const UIDocumentKind: TUIDocumentKindClass;
    NotPerformedDocumentsReportPresenter: INotPerformedDocumentsReportPresenter
  );
begin

  FNotPerformedDocumentsReportPresenterRegistry.RegisterInterface(
    UIDocumentKind, NotPerformedDocumentsReportPresenter
  );

end;

function TStandardDocumentReportPresenterRegistry.
  GetNotPerformedDocumentsReportPresenter(
    const UIDocumentKind: TUIDocumentKindClass
  ): INotPerformedDocumentsReportPresenter;
begin

  Result :=
    INotPerformedDocumentsReportPresenter(
      FNotPerformedDocumentsReportPresenterRegistry.GetInterface(
        UIDocumentKind
      )
    );

end;

procedure TStandardDocumentReportPresenterRegistry.RegisterDocumentApprovingSheetPresenter(
  UIDocumentKind: TUIDocumentKindClass;
  DocumentApprovingSheetPresenter: IDocumentApprovingSheetPresenter
);
begin

  FDocumentApprovingSheetPresenterRegistry.RegisterInterface(
    UIDocumentKind,
    DocumentApprovingSheetPresenter
  );

end;

procedure TStandardDocumentReportPresenterRegistry.
  RegisterDocumentPrintFormPresenter(
    UIDocumentKind: TUIDocumentKindClass;
    DocumentPrintFormPresenter: IDocumentPrintFormPresenter
  );
begin

  FDocumentPrintFormPresenterRegistry.RegisterInterface(
    UIDocumentKind, DocumentPrintFormPresenter
  );

end;

function TStandardDocumentReportPresenterRegistry.
  GetDocumentApprovingSheetPresenter(
    UIDocumentKind: TUIDocumentKindClass
  ): IDocumentApprovingSheetPresenter;
begin

  Result :=
    IDocumentApprovingSheetPresenter(
      FDocumentApprovingSheetPresenterRegistry.GetInterface(UIDocumentKind)
    );

end;

function TStandardDocumentReportPresenterRegistry.
  GetDocumentPrintFormPresenter(
    UIDocumentKind: TUIDocumentKindClass
  ): IDocumentPrintFormPresenter;
begin

  Result :=
    IDocumentPrintFormPresenter(
      FDocumentPrintFormPresenterRegistry.GetInterface(UIDocumentKind)
    );

end;

end.
