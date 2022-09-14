unit DocumentChargesFormViewModelUnit;

interface

uses

  SysUtils,
  Classes,
  DocumentChargeKindDto,
  DocumentChargeSetHolder,
  DB;

type

  TDocumentChargesFormViewModel = class

    private

      {
        refactor(TDocumentChargesFormViewModel, 1): удалить зависимость от TDocumentChargeKindDto
        в случае, если для документа будет допустимым назначение поручений разных типов.
        Тогда необходимо будет получать экземпляр TDocumentChargeKindDto
        для каждого выбираемого пользователем типа поручения в соответствующей
        области карточки документа
      }
      FDocumentChargeKindDto: TDocumentChargeKindDto;
      FDocumentChargeSetHolder: TDocumentChargeSetHolder;

      procedure SetDocumentChargeSetHolder(DocumentChargeSetHolder: TDocumentChargeSetHolder);
      procedure SetDocumentChargeKindDto(const Value: TDocumentChargeKindDto);

    public

      destructor Destroy; override;

      property DocumentChargeKindDto: TDocumentChargeKindDto
      read FDocumentChargeKindDto write SetDocumentChargeKindDto;
      
      property DocumentChargeSetHolder: TDocumentChargeSetHolder
      read FDocumentChargeSetHolder write SetDocumentChargeSetHolder;

  end;

  TDocumentChargesFormViewModelClass =
    class of TDocumentChargesFormViewModel;

implementation

{ TDocumentChargesFormViewModel }

destructor TDocumentChargesFormViewModel.Destroy;
begin

  FreeAndNil(FDocumentChargeKindDto);
  FreeAndNil(FDocumentChargeSetHolder);
  
  inherited;

end;

procedure TDocumentChargesFormViewModel.SetDocumentChargeKindDto(
  const Value: TDocumentChargeKindDto);
begin

  if FDocumentChargeKindDto = Value then Exit;
  
  FreeAndNil(FDocumentChargeKindDto);

  FDocumentChargeKindDto := Value;

end;

procedure TDocumentChargesFormViewModel.SetDocumentChargeSetHolder(
  DocumentChargeSetHolder: TDocumentChargeSetHolder
);
begin

  if DocumentChargeSetHolder <> FDocumentChargeSetHolder then
    FreeAndNil(FDocumentChargeSetHolder);

  FDocumentChargeSetHolder := DocumentChargeSetHolder;

end;

end.
