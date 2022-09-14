unit DocumentReportPresenterRegistry;

interface

uses

  IDocumentReportPresenterRegistryUnit,
  NotPerformedDocumentsReportPresenter,
  SysUtils,
  Classes,
  UIDocumentKinds,
  DocumentPrintFormPresenter,
  DocumentApprovingSheetPresenter;

type

  TDocumentReportPresenterRegistry =
    class abstract (TInterfacedObject, IDocumentReportPresenterRegistry)

      private

        class var FInstance: IDocumentReportPresenterRegistry;

      public

        class function GetCurrent: IDocumentReportPresenterRegistry; static;
        
        class procedure SetCurrent(
          DocumentReportPresenterRegistry: IDocumentReportPresenterRegistry
        ); static;

      public

        procedure RegisterNotPerformedDocumentsReportPresenter(
          const UIDocumentKind: TUIDocumentKindClass;
          NotPerformedDocumentsReportPresenter: INotPerformedDocumentsReportPresenter
        ); virtual; abstract;

        function GetNotPerformedDocumentsReportPresenter(
          const UIDocumentKind: TUIDocumentKindClass
        ): INotPerformedDocumentsReportPresenter; virtual; abstract;

      public
      
        procedure RegisterDocumentPrintFormPresenter(
          UIDocumentKind: TUIDocumentKindClass;
          DocumentPrintFormPresenter: IDocumentPrintFormPresenter
        ); virtual; abstract;

        function GetDocumentPrintFormPresenter(
          UIDocumentKind: TUIDocumentKindClass
        ): IDocumentPrintFormPresenter; virtual; abstract;

      public

        procedure RegisterDocumentApprovingSheetPresenter(
          UIDocumentKind: TUIDocumentKindClass;
          DocumentApprovingSheetPresenter: IDocumentApprovingSheetPresenter
        ); virtual; abstract;

        function GetDocumentApprovingSheetPresenter(
          UIDocumentKind: TUIDocumentKindClass
        ): IDocumentApprovingSheetPresenter; virtual; abstract;
        
      public
      
        class property Current: IDocumentReportPresenterRegistry
        read GetCurrent write SetCurrent;

    end;

implementation

{ TStandardDocumentReportPresenterRegistry }

class function TDocumentReportPresenterRegistry.GetCurrent: IDocumentReportPresenterRegistry;
begin

  Result := FInstance;
  
end;

class procedure TDocumentReportPresenterRegistry.SetCurrent(
  DocumentReportPresenterRegistry: IDocumentReportPresenterRegistry);
begin

  FInstance := DocumentReportPresenterRegistry;
  
end;

end.
