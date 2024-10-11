import 'package:basketball_statistics/app/domain/dto/dto_afterMatch.dart';

abstract class IDaoAftermatch {
  Future<DTOAfterMatch> getMatchStatistics(int matchId);
}
