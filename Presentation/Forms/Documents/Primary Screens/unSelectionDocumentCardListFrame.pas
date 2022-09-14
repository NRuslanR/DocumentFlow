unit unSelectionDocumentCardListFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardListFrame, StdCtrls, ExtCtrls,
  BaseDocumentsReferenceFormUnit, unDocumentCardFrame, DBDataTableFormUnit,
  DocumentRecordViewModel;

type

  TOnDocumentsChoosedEventHandler =
    procedure (
      Sender: TObject;
      ChoosedDocuments: TDocumentRecordViewModels
    ) of object;
    
  TSelectionDocumentCardListFrame = class(TDocumentCardListFrame)

    private

      FOnDocumentsChoosedEventHandler: TOnDocumentsChoosedEventHandler;

    private

      procedure OnRecordsChoosedEventHandler(
        Sender: TObject;
        SelectedRecords: TDBDataTableRecords
      );
      
      function GetSelectedDocumentRecords: TDocumentRecordViewModels;

    protected

      procedure RestoreUIControlProperties; override;
      procedure SaveUIControlProperties; override;

    protected

      procedure CustomizeBaseDocumentsReferenceForm(
        DocumentsReferenceForm: TBaseDocumentsReferenceForm
      ); override;

      procedure CustomizeDocumentCardFrame(
        DocumentCardFrame: TDocumentCardFrame
      ); override;
    
    public

      destructor Destroy; override;

      property SelectedDocumentRecords: TDocumentRecordViewModels
      read GetSelectedDocumentRecords;

    public

      property OnDocumentsChoosedEventHandler: TOnDocumentsChoosedEventHandler
      read FOnDocumentsChoosedEventHandler write FOnDocumentsChoosedEventHandler;

  end;

var
  SelectionDocumentCardListFrame: TSelectionDocumentCardListFrame;

implementation

{$R *.dfm}

{ TSelectionDocumentCardListFrame }

procedure TSelectionDocumentCardListFrame.CustomizeBaseDocumentsReferenceForm(
  DocumentsReferenceForm: TBaseDocumentsReferenceForm
);
begin

  inherited CustomizeBaseDocumentsReferenceForm(DocumentsReferenceForm);

  DocumentsReferenceForm.ViewOnly := True;
  DocumentsReferenceForm.ChooseRecordActionVisible := True;
  DocumentsReferenceForm.OnRecordsChoosedEventHandler :=
    OnRecordsChoosedEventHandler;

end;

procedure TSelectionDocumentCardListFrame.CustomizeDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame);
begin

  inherited;

  DocumentCardFrame.ViewOnly := True;

end;

destructor TSelectionDocumentCardListFrame.Destroy;
begin

  FDocumentsReferenceFormFactory := nil;
  
  inherited;

end;

function TSelectionDocumentCardListFrame.GetSelectedDocumentRecords: TDocumentRecordViewModels;
begin

  Result := FBaseDocumentsReferenceForm.SelectedDocumentRecordViewModels;

end;

procedure TSelectionDocumentCardListFrame.OnRecordsChoosedEventHandler(
  Sender: TObject;
  SelectedRecords: TDBDataTableRecords
);
var
    SelectedDocumentRecordViewModels: TDocumentRecordViewModels;
begin

  if Assigned(FOnDocumentsChoosedEventHandler) then begin

    SelectedDocumentRecordViewModels :=
      FBaseDocumentsReferenceForm.SelectedDocumentRecordViewModels;

    FOnDocumentsChoosedEventHandler(Self, SelectedDocumentRecordViewModels);

  end;
  
end;

procedure TSelectionDocumentCardListFrame.RestoreUIControlProperties;
begin

  //inherited;

end;

procedure TSelectionDocumentCardListFrame.SaveUIControlProperties;
begin

  //inherited;

end;

end.
