unit IDocumentReportPresenterRegistryUnit;

interface

uses

  UIDocumentKinds,
  NotPerformedDocumentsReportPresenter,
  DocumentPrintFormPresenter,
  DocumentApprovingSheetPresenter,
  SysUtils,
  Classes;

type

  IDocumentReportPresenterRegistry = interface

    procedure RegisterNotPerformedDocumentsReportPresenter(
      const UIDocumentKind: TUIDocumentKindClass;
      NotPerformedDocumentsReportPresenter: INotPerformedDocumentsReportPresenter
    );

    function GetNotPerformedDocumentsReportPresenter(
      const UIDocumentKind: TUIDocumentKindClass
    ): INotPerformedDocumentsReportPresenter;
    
    procedure RegisterDocumentPrintFormPresenter(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentPrintFormPresenter: IDocumentPrintFormPresenter
    );

    function GetDocumentPrintFormPresenter(
      UIDocumentKind: TUIDocumentKindClass
    ): IDocumentPrintFormPresenter;

    procedure RegisterDocumentApprovingSheetPresenter(
      UIDocumentKind: TUIDocumentKindClass;
      DocumentApprovingSheetPresenter: IDocumentApprovingSheetPresenter
    );

    function GetDocumentApprovingSheetPresenter(
      UIDocumentKind: TUIDocumentKindClass
    ): IDocumentApprovingSheetPresenter;

  end;

implementation

end.
