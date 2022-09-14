unit DocumentCardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardFrame, DeletableOnCloseFormUnit, frxClass,
  frxExportXLS;

type

  TDocumentCardForm = class(TDeletableOnCloseForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    private
    
      function GetOnCloseFormChangedDocumentDataSaveMessage: String;
      procedure SetOnCloseFormChangedDocumentDataSaveMessage(const Value: String);
    
    protected

      FOnCloseFormChangedDocumentDataSaveMessage: String;
      FDocumentCardFrame: TDocumentCardFrame;

      procedure InflateDocumentCardFrame(DocumentCardFrame: TDocumentCardFrame);
      procedure SetCardFrame(Value: TDocumentCardFrame);

      function RequestSaveChangedDataConfirmationOnCloseIfNecessary: Integer;
      
    public

      destructor Destroy; override;

      constructor Create(
        DocumentCardFrame: TDocumentCardFrame;
        AOwner: TComponent
      );

      property CardFrame: TDocumentCardFrame
      read FDocumentCardFrame write SetCardFrame;

      property OnCloseFormChangedDocumentDataSaveMessage: String
      read GetOnCloseFormChangedDocumentDataSaveMessage
      write SetOnCloseFormChangedDocumentDataSaveMessage;
      
  end;

var
  DocumentCardForm: TDocumentCardForm;

implementation

uses

  AuxWindowsFunctionsUnit;

{$R *.dfm}

{ TDocumentCardForm }

constructor TDocumentCardForm.Create(
  DocumentCardFrame: TDocumentCardFrame;
  AOwner: TComponent
);
begin

  inherited Create(AOwner);

  InsertComponent(DocumentCardFrame);
  InflateDocumentCardFrame(DocumentCardFrame);

end;

destructor TDocumentCardForm.Destroy;
begin
  
  inherited;

end;

procedure TDocumentCardForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  inherited;

  case RequestSaveChangedDataConfirmationOnCloseIfNecessary of

    ID_YES:
    begin

      if FDocumentCardFrame.SaveData = srNotValidData then
        Action := caNone;

    end;

    ID_NO:
    begin

    end;

    ID_CANCEL:
    begin

      Action := caNone;

    end;
      
  end;

end;

function TDocumentCardForm.GetOnCloseFormChangedDocumentDataSaveMessage: String;
begin

  Result := FOnCloseFormChangedDocumentDataSaveMessage;
  
end;

procedure TDocumentCardForm.InflateDocumentCardFrame(
  DocumentCardFrame: TDocumentCardFrame
);
begin

  ClientWidth := DocumentCardFrame.Width;
  ClientHeight := DocumentCardFrame.Height;

  DocumentCardFrame.Parent := Self;
  DocumentCardFrame.Align := alClient;

  FDocumentCardFrame := DocumentCardFrame;

end;

function TDocumentCardForm.RequestSaveChangedDataConfirmationOnCloseIfNecessary: Integer;
begin

  if not Assigned(FDocumentCardFrame) then Exit;

  if not FDocumentCardFrame.IsDataChanged then Exit;

  Result :=
    ShowQuestionMessage(
      Self.Handle,
      FOnCloseFormChangedDocumentDataSaveMessage,
      'Сообщение',
      MB_YESNOCANCEL
    );
  
end;

procedure TDocumentCardForm.SetCardFrame(Value: TDocumentCardFrame);
begin

    FDocumentCardFrame := Value;

    InflateDocumentCardFrame(Value);
    
end;

procedure TDocumentCardForm.SetOnCloseFormChangedDocumentDataSaveMessage(
  const Value: String);
begin

  FOnCloseFormChangedDocumentDataSaveMessage := Value;

end;

end.
