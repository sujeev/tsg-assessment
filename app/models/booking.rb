class Booking < ApplicationRecord
  belongs_to :court
  belongs_to :user

  scope :filter_by_date, -> ( requested_date) { where(date_time:(requested_date.midnight)..(((requested_date + 1.day).midnight) - 1.second))}
  scope :filter_by_sport, -> ( sport) { joins(court: :sport).where( courts:{ sports: {name: sport}})}

  def self.available_slots( requested_date, sport)
    lookup_date = requested_date ? Date.parse( requested_date) : Date.today
    bookings = Booking.filter_by_date( lookup_date)
    bookings = bookings.filter_by_sport( sport) if sport
    bookings = bookings.select( :court_id, :date_time).map { |e| {court_id: e.court_id, date: e.date_time.to_date, time: e.date_time.hour} }

    # bookings
    calculate_available_slots( lookup_date, sport, bookings)
  end

  private

  def self.calculate_available_slots( lookup_date, sport, bookings)
    courts = []
    if sport
      courts = Court.joins( :sport).where( sports:{name: sport}).order( :name)
    else
      courts = Court.all.order( :name)
    end

    slots = []
    courts.each do |court|
      court_slots = []
      daily_slots( lookup_date).each do |hour|
        slot = { court_id: court.id, date: lookup_date.to_date, time: hour}
        court_slots << slot unless bookings.include? slot
      end
      slots << { court: court, slots: court_slots}
    end

    slots
  end

  def self.daily_slots(lookup_date)
    (1..24)
  end
end
