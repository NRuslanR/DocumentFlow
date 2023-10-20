unit LoodsmanDocumentUploadingInfoFormViewModel;

interface

uses

  LoodsmanDocumentUploadingInfo,
  SysUtils,
  Classes;

type

  TLoodsmanDocumentUploadingControlToolsInfoViewModel = class

    public

      UploadingToolCaption: String;
      UploadingToolVisible: Boolean;
      UploadingToolActive: Boolean;

      CancellationToolCaption: String;
      CancellationToolVisible: Boolean;
      CancellationToolActive: Boolean;
      
  end;

  TLoodsmanDocumentUploadingInfoFormViewModel = class

    private

      FStatusNames: TStrings;
      
      FUploadingControlToolsInfoViewModel:
        TLoodsmanDocumentUploadingControlToolsInfoViewModel;

      procedure SetUploadingControlToolsInfoViewModel(
        const Value: TLoodsmanDocumentUploadingControlToolsInfoViewModel);

      procedure SetStatusNames(const Value: TStrings);

    public

      StatusName: String;
      StatusDateTime: TDateTime;
      StatusInitiatorFullName: String;
      ErrorMessage: String;
      IsAccessible: Boolean;
      
      destructor Destroy; override;
      constructor Create;

      property StatusNames: TStrings read FStatusNames write SetStatusNames;
      
      property UploadingControlToolsInfoViewModel: TLoodsmanDocumentUploadingControlToolsInfoViewModel
      read FUploadingControlToolsInfoViewModel write SetUploadingControlToolsInfoViewModel;
      
  end;
  
implementation

{ TLoodsmanDocumentUploadingInfoFormViewModel }

constructor TLoodsmanDocumentUploadingInfoFormViewModel.Create;
begin

  inherited Create;

  Self.UploadingControlToolsInfoViewModel := TLoodsmanDocumentUploadingControlToolsInfoViewModel.Create;

end;

destructor TLoodsmanDocumentUploadingInfoFormViewModel.Destroy;
begin

  FreeAndNil(FUploadingControlToolsInfoViewModel);

  inherited;

end;

procedure TLoodsmanDocumentUploadingInfoFormViewModel.SetStatusNames(
  const Value: TStrings);
begin

  if FStatusNames = Value then Exit;

  FreeAndNil(FStatusNames);
  
  FStatusNames := Value;

end;

procedure TLoodsmanDocumentUploadingInfoFormViewModel.SetUploadingControlToolsInfoViewModel(
  const Value: TLoodsmanDocumentUploadingControlToolsInfoViewModel);
begin

  if FUploadingControlToolsInfoViewModel = Value then Exit;

  FreeAndNil(FUploadingControlToolsInfoViewModel);
  
  FUploadingControlToolsInfoViewModel := Value;

end;

end.
