unit unPersonnelOrderCardFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardFrame, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, StdCtrls,
  cxButtons, ExtCtrls, ComCtrls, PersonnelOrderCardFormViewModel,
  unPersonnelOrderMainInformationFrame, DocumentMainInformationFrameUnit,
  PersonnelOrderSubKindViewModel, unPersonnelOrderApprovingsFrame;

type

  TPersonnelOrderCardFrame = class(TDocumentCardFrame)

  private

    function GetViewModel: TPersonnelOrderCardFormViewModel;
    procedure SetViewModel(ViewModel: TPersonnelOrderCardFormViewModel);

    function GetPersonnelOrderMainInformationFrame: TPersonnelOrderMainInformationFrame;
    function GetPersonnelOrderApprovingsFrame: TPersonnelOrderApprovingsFrame;
    
  protected

    procedure AssignDocumentMainInformationFrame(
      DocumentMainInformationFrame: TDocumentMainInformationFrame
    ); override;

  protected

    procedure RestoreUIControlProperties; override;
    procedure SaveUIControlProperties; override;

  private

    procedure HandlePersonnelOrderSubKindChangedEvent(
      Sender: TObject;
      NewSubKindViewModel: TPersonnelOrderSubKindViewModel
    );

  public

    property ViewModel: TPersonnelOrderCardFormViewModel
    read GetViewModel write SetViewModel;

  published

    property DocumentMainInformationFrame: TPersonnelOrderMainInformationFrame
    read GetPersonnelOrderMainInformationFrame;

    property DocumentApprovingsFrame: TPersonnelOrderApprovingsFrame
    read GetPersonnelOrderApprovingsFrame;
    
  end;

var
  PersonnelOrderCardFrame: TPersonnelOrderCardFrame;

implementation

{$R *.dfm}

{ TPersonnelOrderCardFrame }

procedure TPersonnelOrderCardFrame.AssignDocumentMainInformationFrame(
  DocumentMainInformationFrame: TDocumentMainInformationFrame
);
begin

  inherited;

  with DocumentMainInformationFrame as TPersonnelOrderMainInformationFrame
  do begin

    OnPersonnelOrderSubKindChangedEventHandler :=
      HandlePersonnelOrderSubKindChangedEvent;

  end;

end;

function TPersonnelOrderCardFrame.GetPersonnelOrderApprovingsFrame: TPersonnelOrderApprovingsFrame;
begin

  Result := inherited DocumentApprovingsFrame as TPersonnelOrderApprovingsFrame;

end;

function TPersonnelOrderCardFrame.GetPersonnelOrderMainInformationFrame: TPersonnelOrderMainInformationFrame;
begin

  Result := inherited DocumentMainInformationFrame as TPersonnelOrderMainInformationFrame;

end;

function TPersonnelOrderCardFrame.GetViewModel: TPersonnelOrderCardFormViewModel;
begin

  Result := TPersonnelOrderCardFormViewModel(inherited GetViewModel);
  
end;

procedure TPersonnelOrderCardFrame.HandlePersonnelOrderSubKindChangedEvent(
  Sender: TObject;
  NewSubKindViewModel: TPersonnelOrderSubKindViewModel
);
begin

  DocumentApprovingsFrame.CreateNewApprovingCycleForPersonnelOrderSubKind(
    NewSubKindViewModel.Id
  );
  
end;

procedure TPersonnelOrderCardFrame.RestoreUIControlProperties;
begin

  //inherited RestoreUIControlProperties;

end;

procedure TPersonnelOrderCardFrame.SaveUIControlProperties;
begin

  //inherited SaveUIControlProperties;

end;

procedure TPersonnelOrderCardFrame.SetViewModel(
  ViewModel: TPersonnelOrderCardFormViewModel);
begin

  inherited SetViewModel(ViewModel);
  
end;

end.
